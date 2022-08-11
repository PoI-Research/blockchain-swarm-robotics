# Managing Byzantine Robots via Blockchain Technology in a Swarm Robotics Collective Decision Making Scenario

## Instructions
The instructions to set up the server on Linux are given below.
### Linux
We consider $SERVER as the path of this repo on your machine. Wherever you see this placeholder value, remember to replace it with the absolute path of this repo.

1. Install the following dependencies

```bash
sudo apt-get install cmake libfreeimage-dev libfreeimageplus-dev \
  qt5-default freeglut3-dev libxi-dev libxmu-dev liblua5.3-dev \
  lua5.3 doxygen graphviz libgraphviz-dev asciidoc g++
```
If qt5-default is not found, install it by running the following command:
```bash
sudo apt-get install qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools
```

2. Install Python
3. Install ARGoS 3 by running the following command:
```bash
./scripts/install_argos.sh
```
4. Source the setup_argos3 file
```bash
source $SERVER/argos3-dist/bin/setup_argos3
```
5. Install go 1.7.3.
6. Add the following to your ~/.bashrc file: (We assume that you have placed the go binaries in the `home` directory.)
```bash
export GOROOT=$HOME/go
export PATH=$PATH:$GOROOT/bin
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
```
7. Run
```bash
./scripts/create-geths.sh
```
8. Run
```bash
./create_sc.sh
```
9. Install Ethereum and Solidity compiler.
```bash
sudo add-apt-repository ppa:ethereum/ethereum
sudo apt-get update
sudo apt-get install solc
```
10. Install npm.
11. Install solc@0.4.8
12. Build the repo:
```bash
mkdir build
cd build
cmake ..
make
```
13. Add this to `~/.bashrc`:
```bash
export PATH=$PATH:$SERVER/go-ethereum0/build/bin
```
14. Install Redis by running the following commands:
```bash
curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list

sudo apt-get update
sudo apt-get install redis

sudo apt-get install libhiredis-dev

./install_redis.sh
```
15. Run Redis by running:
```bash
redis-server
```
16. Run the server by running:
```bash
cd node-server
node server.js
```

The server will be running on port `3000`.

## Frontend Application
The frontend application that communicates with this server and allows you to run experiments a lot more easily is available on [Blockchain Swarm Robotics Lab](https://github.com/PoI-Research/blockchain-swarm-robotics-lab).
## Decision Rules
| Index | Decision Rule |
|:----|:--------|
|1 | DMVD|
|2 | DC |
|3 | DMMD |

## Byzantine Swarm Style
| Index | Byzantine Swarm Style |
|:------|:--------------|
| 0     | No Byzantine robots |
| 1     | All Byzantine robots are white |
| 2     | All Byzantine robots are black |
| 3     | A half of Byzantine robots are black and the other half are white          |
| 5     | All Byzantine robots are black          |

## Requirements:
- ARGoS 3
- ARGoS-epuck
- git
- cmake
- golang (tested with version 1.7.3)
- optional: sendmail

## Scenario

Using the robot swarm simulator ARGoS 3, we study a collective
decision scenario, in which robots sense which of two features in an
environment is the most frequent one---a best-of-2 problem. Our
approach is based on the collective decision scenario of Valentini et
al. Via blockchain-based smart contracts using the Ethereum protocol,
we add a security layer on top of the classical approach that allows
to take care of the presence of Byzantine robots. Our blockchain
approach also allows to log events in a tamper-proof way: these logs
can then be used to analyze, if necessary, the behavior of the robots
in the swarm without incurring the risk that some malicious agent has
modified them. In addition, it provides a new way to understand how we
debug and do data forensics on decentralized systems such as robot

The goal of the robot swarm is to make a collective decision and to
reach consensus on the most frequent tile color of a black/white
grid. Each robot has a current opinion about the correct color, and
via dissemination/decision-making strategies, they influence their
peers. At the end of a successful run, all robots have the opinion of
the majority color (in our experiments it is always the white).
