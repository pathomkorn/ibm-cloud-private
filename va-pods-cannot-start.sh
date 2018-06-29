#!/bin/bash
kubectl patch statefulset/vulnerability-advisor-kafka -n kube-system -p '{"spec":{"template":{"spec":{"containers":[{"command":["bash","-c","KAFKA_BROKER_ID=$((${HOSTNAME##*-}+1001)) KAFKA_RESERVED_BROKER_MAX_ID=$((${HOSTNAME##*-}+1001)) /usr/bin/start-kafka.sh"],"env":[{"name":"KAFKA_DELETE_TOPIC_ENABLE","value":"true"}],"name":"kafka-server"}]}}}}'
