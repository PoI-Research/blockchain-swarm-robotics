BASE="$HOME/blockchain-swarm-robotics"

cd "$BASE"
BLOCKCHAINPATH="$HOME/eth_data_para$1" # always without '/' at the end!!
BASEPORT=$((33000 + $1 * 200))

rm -rf "$BLOCKCHAINPATH"
rm genesis/"genesis$BASEPORT.json"
