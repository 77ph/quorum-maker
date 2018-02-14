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

echo "[*] Starting Constellation node" > qdata/logs/node24.log

cp qdata/node24.conf .

PATTERN="s/#CURRENT_NODE_IP#/${CURRENT_NODE_IP}/g"
PATTERN2="s/#MAIN_NODE_IP#/${MAIN_NODE_IP}/g"
PATTERN3="s/#C_PORT#/${C_PORT}/g"
PATTERN4="s/#M_C_PORT#/${MAIN_C_PORT}/g"

sed -i "$PATTERN" node24.conf
sed -i "$PATTERN2" node24.conf
sed -i "$PATTERN3" node24.conf
sed -i "$PATTERN4" node24.conf


constellation-node node24.conf 2>> qdata/logs/node24.log &
sleep 1

echo "[*] Starting node24 node" >> qdata/logs/constellation_node24.log
echo "[*] geth --verbosity 6 --datadir qdata" $GLOBAL_ARGS" --rpcport "$R_PORT "--port "$W_PORT "  --minblocktime 2 --maxblocktime 5 --nat extip:"$CURRENT_NODE_IP>> qdata/logs/node24.log

PRIVATE_CONFIG=node24.conf geth --verbosity 6 --datadir qdata $GLOBAL_ARGS --rpcport $R_PORT --port $W_PORT   --minblocktime 2 --maxblocktime 5 --nat extip:$CURRENT_NODE_IP 2>>qdata/logs/node24.log 

