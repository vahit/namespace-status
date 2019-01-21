#!/bin/bash

# Sample script to create tmux template for k8s cluster status

CONTEXT=${1}
NAMESPACE="${2}"
INTERVAL=${3:-2}
[[ -z "${NAMESPACE}" || -z "${CONTEXT}" ]] && echo "usage: $(basename ${0}) CONTEXT NAMESPACE." && exit 1

# Create new window
tmux new-window -n "K8S status" "exec watch --no-title -d \"kubectl --context ${CONTEXT} --namespace "${NAMESPACE}" get pod --output custom-columns='NAME:.metadata.name,STATUS:.status.phase,RESTARTS:.status.containerStatuses[*].restartCount,NODE:.spec.nodeName' --no-headers | grep -v Succeeded"\"

# Create new pane
tmux split -v -p 21 "exec watch --interval ${INTERVAL} --no-title -d kubectl --context ${CONTEXT} --namespace "${NAMESPACE}" get hpa"

tmux select-pane -t 1
tmux split -v -p 47 "exec watch --interval ${INTERVAL} --no-title -d \"kubectl --context ${CONTEXT} --namespace "${NAMESPACE}" top pod | tail --lines +2 | sed 's/  */|/g' | column -s'|' -t\"
 # \"kubectl --context ${CONTEXT} --namespace "${NAMESPACE}" top pod | tail --lines +2 | column\""

# Back to the previuse pane
# tmux select-pane -t 1
tmux split -h -p 40 "exec watch --interval ${INTERVAL} --no-title -d \"kubectl --context ${CONTEXT} top node | tail --lines +2 | sed 's/  */ /g' | cut -f1,3,5 -d ' ' | sed 's/ /\t/g'\""

