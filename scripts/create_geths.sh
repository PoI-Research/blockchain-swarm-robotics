BASE=`pwd`
git clone https://github.com/thivi/go-ethereum.git
cd go-ethereum
#git checkout eee96a5b
#git checkout -b fixeddiff

mv core/block_validator.go core/block_validator.go.template
#mv consensus/ethash/consensus.go consensus/ethash/consensus.go.template
mv circle.yml circle.yml.template
#mv vendor/github.com/ethereum/ethash/ethash.go vendor/github.com/ethereum/ethash/ethash.go.template

sed -i '268s/.*/return big.NewInt(MININGDIFF)/' core/block_validator.go.template
sed -i '270s/.*/return big.NewInt(MININGDIFF)/' core/block_validator.go.template

#sed -i '284s/.*/return big.NewInt(MININGDIFF)/' consensus/ethash/consensus.go.template
#sed -i '286s/.*/return big.NewInt(MININGDIFF)/' consensus/ethash/consensus.go.template

sed -i '7s/ethash/ethashMYNUMBER/' circle.yml.template
#sed -i '70s/ethash/ethashMYNUMBER/' vendor/github.com/ethereum/ethash/ethash.go.template

RESERVEDNODES=0
i="$RESERVEDNODES"

if [ $# -eq 0 ]
  then
    MININGDIFF=200000
else
    MININGDIFF=$1
fi

mv "$BASE/go-ethereum/" "$BASE/go-ethereum${i}"

TEMPLATEA="$BASE/go-ethereum${i}/circle.yml.template"
#TEMPLATEB="$BASE/go-ethereum/vendor/github.com/ethereum/ethash/ethash.go.template"
TEMPLATEC="$BASE/go-ethereum${i}/core/block_validator.go.template"

OUTFILEA="$BASE/go-ethereum${i}/circle.yml"

sed -e "s|MYNUMBER|$i|g" $TEMPLATEA > $OUTFILEA

#OUTFILEB="$BASE/go-ethereum${i}/vendor/github.com/ethereum/ethash/ethash.go"
#sed -e "s|MYNUMBER|$i|g" $TEMPLATEB > $OUTFILEB

OUTFILEC="$BASE/go-ethereum${i}/core/block_validator.go"

sed -e "s|MININGDIFF|$MININGDIFF|g" $TEMPLATEC > $OUTFILEC

make -C "$BASE/go-ethereum${i}"
mv "$BASE/go-ethereum${i}/build/bin/geth" "$BASE/go-ethereum${i}/build/bin/geth${i}"
