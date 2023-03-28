#!/bin/bash
echo "Start cpuminer with Parameters: --config=config.json --password c=LTC,ID=docker-$HOSTNAME"
./cpuminer --config=config.json --password c=LTC,ID=balena-$HOSTNAME