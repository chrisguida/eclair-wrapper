#!/bin/sh

JAVA_OPTS='-Xmx512m -Declair.api.binding-ip=0.0.0.0 -Declair.api.enabled=true -Declair.api.password=password -Declair.bitcoind.host=bitcoind.embassy -Declair.bitcoind.rpcuser=bitcoin -Declair.bitcoind.rpcpassword=<your-rpc-password-here> -Declair.bitcoind.zmqblock=tcp://bitcoind.embassy:28332 -Declair.bitcoind.zmqtx=tcp://bitcoind.embassy:28333 -Declair.bitcoind.wallet=eclair -Declair.printToConsole'

exec eclair-node/bin/eclair-node.sh "-Declair.datadir=${ECLAIR_DATADIR}"
