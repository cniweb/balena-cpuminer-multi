#!/bin/bash
echo "Start cpuminer with Parameters: --config=config.json --pass c=LTC,ID=balena-$HOSTNAME"
cpuminer --config=config.json --pass c=LTC,ID=balena-$HOSTNAME