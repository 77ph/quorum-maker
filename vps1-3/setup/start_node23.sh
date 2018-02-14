#!/bin/bash
set -u
set -e
NETID=87234


echo 'CURRENT_IP='$CURRENT_NODE_IP > ../setup.conf
echo 'RPC_PORT='$R_PORT >> ../setup.conf
echo 'WHISPER_PORT='$W_PORT >> ../setup.conf
echo 'CONSTELLATION_PORT='$C_PORT >> ../setup.conf
echo 'BOOTNODE_PORT='$BOOTNODE_PORT >> ../setup.conf
echo 'MASTER_IP='$MAIN_NODE_IP >> ../setup.conf
echo 'MASTER_CONSTELLATION_PORT='$MAIN_C_PORT >> ../setup.conf

BOOTNODE_ENODE=enode://1d86386962d720798e61991fefc9d138e4c8eaa09da270f1bc51791fb246a790a2790233af3304e5b7b951b42e81d2f4547c165d18d990221bc562dc9d727633@[$MAIN_NODE_IP]:$BOOTNODE_PORT

GLOBAL_ARGS="--bootnodes $BOOTNODE_ENODE --networkid $NETID --rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum"

echo "[*] Starting Constellation node" > qdata/logs/node23.log

cp qdata/node23.conf .

PATTERN="s/#CURRENT_NODE_IP#/${CURRENT_NODE_IP}/g"
PATTERN2="s/#MAIN_NODE_IP#/${MAIN_NODE_IP}/g"
PATTERN3="s/#C_PORT#/${C_PORT}/g"
PATTERN4="s/#M_C_PORT#/${MAIN_C_PORT}/g"

sed -i "$PATTERN" node23.conf
sed -i "$PATTERN2" node23.conf
sed -i "$PATTERN3" node23.conf
sed -i "$PATTERN4" node23.conf


constellation-node node23.conf 2>> qdata/logs/node23.log &
sleep 1

echo "[*] Starting node23 node" >> qdata/logs/constellation_node23.log
echo "[*] geth --verbosity 6 --datadir qdata" $GLOBAL_ARGS" --rpcport "$R_PORT "--port "$W_PORT " --voteaccount "0x53c24b993edeeda65ef9b6c00531e5c0983609ad" --votepassword "" --minblocktime 2 --maxblocktime 5 --nat extip:"$CURRENT_NODE_IP>> qdata/logs/node23.log

PRIVATE_CONFIG=node23.conf geth --verbosity 6 --datadir qdata $GLOBAL_ARGS --rpcport $R_PORT --port $W_PORT  --voteaccount "0x53c24b993edeeda65ef9b6c00531e5c0983609ad" --votepassword "" --minblocktime 2 --maxblocktime 5 --nat extip:$CURRENT_NODE_IP 2>>qdata/logs/node23.log 

