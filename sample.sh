# Usage: bash start_xyz.sh <node1> <node2> <decision_rule> <consensus_algorithm> <no_of_robots> <no_of_repetitions> <byzantine_robots> <use_classical> <percent_black> <byzantine_swarm_style>

NODE1=$1
NODE2=$2
DECISIONRULE=$3
CONSENSUS_ALGORITHM=$4
N_ROBOTS=$5
REPETITIONS=$6
BYZANTINE_ROBOTS=$7
IS_CLASSICAL=$8
BLACK_PERCENT=$9
BYZANTINESWARMSTYLE=${10}
sleep 5
redis-cli publish "experimentData" "{\"secondsTaken\": 100,\"numberOfWhites\": 2,\"numberOfBlacks\": 0,\"numberOfRobots\": $N_ROBOTS,\"isClassical\": $IS_CLASSICAL,\"consensusAlgorithm\": \"$CONSENSUS_ALGORITHM\",\"percentageOfBlackTiles\": $BLACK_PERCENT,\"decisionRule\": $DECISIONRULE,\"byzantineSwarmStyle\": $BYZANTINESWARMSTYLE,\"numberOfByzantineRobots\": $BYZANTINE_ROBOTS}"
