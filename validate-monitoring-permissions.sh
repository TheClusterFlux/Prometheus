#!/bin/bash
# Script to validate permissions within pods

echo "===== Validating Loki Pod Permissions ====="
kubectl exec -it -n monitoring $(kubectl get pods -n monitoring -l app=loki -o name | head -n1) -- \
  sh -c "ls -la /data && id"

echo "===== Validating Prometheus Pod Permissions ====="
kubectl exec -it -n monitoring $(kubectl get pods -n monitoring -l app=prometheus -o name | head -n1) -- \
  sh -c "ls -la /prometheus && id"

echo "===== Validating Grafana Pod Permissions ====="
kubectl exec -it -n monitoring $(kubectl get pods -n monitoring -l app=grafana -o name | head -n1) -- \
  sh -c "ls -la /var/lib/grafana && id"

echo "===== Validating AlertManager Pod Permissions ====="
kubectl exec -it -n monitoring $(kubectl get pods -n monitoring -l app=alertmanager -o name | head -n1) -- \
  sh -c "ls -la /alertmanager && id"
