#!/bin/bash

while true; do
    clear
    kubectl top node | awk '{print $1"\t"$3"\t"$5}' | tail --lines +2
    sleep 3
done
