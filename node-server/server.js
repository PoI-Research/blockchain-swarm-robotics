const { createClient } = require("redis");
const express = require("express");
const app = express();
const http = require("http");
const server = http.createServer(app);
const client = createClient();
const { Server } = require("socket.io");
const io = new Server(server, {
    cors: {
        origin: "*"
    }
});
const { spawn } = require('child_process');
const cors = require("cors");
const JSONdb = require("simple-json-db");
const path = require("path");
var bodyParser = require('body-parser');
const { Parser } = require("json2csv");
const opts = {
    fields: [
        "secondsTaken",
        "numberOfWhites",
        "numberOfBlacks",
        "numberOfRobots",
        "isClassical",
        "consensusAlgorithm",
        "percentageOfBlackTiles",
        "decisionRule",
        "byzantineSwarmStyle",
        "numberOfByzantineRobots",
        "id"
    ]
}

const db = new JSONdb(path.join(__dirname, "..", "storage.json"));
const inputID = process.argv[ 2 ] ? process.argv[ 2 ] : 0;
console.log(inputID)
const EXPERIMENT_DATA = "experimentData";
const QUEUE = "queue";

app.use(cors());
app.use(bodyParser.json());

let lock = false;
let sockets = [];
let id = inputID;
client.on("error", (err) => console.log("Redis Client Error", err));

client.connect().then(() => {
    client.subscribe("experimentData", (data) => {
        try {
            console.log(data);
            currentExperimentData = { ...JSON.parse(data), id };
            if (db.has(EXPERIMENT_DATA)) {
                const existingData = db.get(EXPERIMENT_DATA);
                existingData.push(currentExperimentData);
                db.set(EXPERIMENT_DATA, existingData);
            } else {
                db.set(EXPERIMENT_DATA, [ currentExperimentData ]);
            }
            sockets.forEach(socket => {
                socket.emit("EXPERIMENT_DATA", currentExperimentData);
            });
            lock = false;
        } catch (error) {
            console.log(error);
        }
    });
});

io.on('connection', (socket) => {
    console.log('a user connected');
    sockets.push(socket);

    socket.on("RUN_EXPERIMENTS", async (repetitions) => {
        const queue = db.get(QUEUE);

        if (!(queue && Array.isArray(queue) && queue.length > 0)) {
            socket.emit("ERROR", "The queue is not of the correct format.");

            return;
        }
        console.log("About to loop through...");
        id = inputID;
        for (const experiment of queue) {
            const decsionRule = experiment.decisionRule;
            const percentageOfBlackTiles = experiment.percentageOfBlackTiles;
            const consensusAlgorithm = experiment.consensusAlgorithm;
            const useClassicalApproach = experiment.useClassicalApproach.toString();
            const numberOfByzantineRobots = experiment.numberOfByzantineRobots;
            const byzantineSwarmStyle = experiment.byzantineSwarmStyle;
            const numberOfRobots = experiment.numberOfRobots;

            console.log("Running experiment...");
            console.log(experiment);
            spawn("bash", [ "../scripts/clean_dirs.sh", 0 ]);
            for (i = 0; i < parseInt(repetitions); i++) {
                const process = spawn("bash", ["../scripts/start_experiment.sh",0, 0, decsionRule, consensusAlgorithm, numberOfRobots,1,numberOfByzantineRobots,useClassicalApproach,percentageOfBlackTiles,byzantineSwarmStyle]);
                lock = true;

                process.stdout.on('data', function (data) {
                    console.log(data.toString());
                });

                process.stderr.on('data', function (data) {
                    console.log(data.toString());
                });

                process.on('exit', function (code) {
                    console.log('child process exited with code ' + code.toString());
                });

                while (lock) {
                    await new Promise(resolve => {
                        setTimeout(() => {
                            console.log("Waiting for the current experiment to complete...");
                            resolve();
                        }, 5000);
                    });
                }

                console.log("Experiment done. Next experiment.");
            }
            id++;
        }
        sockets.forEach(socket => {
            socket.emit("EXPERIMENT_COMPLETED");
        });
    })
});

app.get("/queue", (req, res) => {
    if (db.has(QUEUE)) {
        res.send(db.get(QUEUE));

        return;
    }

    res.send([]);
});

app.post("/queue", (req, res) => {
    if (db.has(QUEUE)) {
        const queue = db.get(QUEUE);
        queue.push(req.body);
        db.set(QUEUE, queue);
    } else {
        db.set(QUEUE, [ req.body ]);
    }

    res.send();
});

app.get("/experiment-data", (req, res) => {
    if (db.has(EXPERIMENT_DATA)) {
        res.send(db.get(EXPERIMENT_DATA));

        return;
    }

    res.send([]);
});

app.delete("/queue", (req, res) => {
    db.delete(QUEUE);

    res.send();
});

app.delete("/queue/:id", (req, res) => {
    if (!db.has(QUEUE)) {
        res.status(400).send("Queue is empty");

        return;
    }

    const queue = db.get(QUEUE);
    queue.splice(req.params.id, 1);
    db.set(QUEUE, queue);

    res.send();
});

app.delete("/experiment-data", (req, res) => {
    db.delete(EXPERIMENT_DATA);

    res.send();
})

app.delete("/experiment-data/:id", (req, res) => {
    if (!db.has(EXPERIMENT_DATA)) {
        res.status(400).send("Experiment data is empty");

        return;
    }

    const data = db.get(EXPERIMENT_DATA);
    data.splice(req.params.id, 1);
    db.set(EXPERIMENT_DATA, data);

    res.send();
})

app.get("/convert-to-csv", (req, res) => {
    const parser = new Parser(opts);
    const csv = parser.parse(db.get(EXPERIMENT_DATA));
    res.send(csv);

})
server.listen(3000, () => {
    console.log('listening on *:3000');
});
