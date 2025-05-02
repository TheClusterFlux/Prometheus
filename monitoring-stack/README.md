# Kubernetes Monitoring Stack

This Helm chart installs a complete monitoring solution for Kubernetes clusters, including:

- Prometheus - For metrics collection and storage
- Grafana - For visualization and dashboarding
- AlertManager - For alerting based on metrics
- Node Exporter - For collecting node metrics
- kube-state-metrics - For collecting Kubernetes object metrics
- Loki - For log aggregation and search
- Promtail - For shipping logs to Loki

## Prerequisites

- Kubernetes 1.16+
- Helm 3.0+
- Persistent volumes provisioner support in the underlying infrastructure (for Prometheus, Grafana, and Loki storage)

## Installation

### Add Required Helm Repositories

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
```

### Update Dependencies

```bash
helm dependency update ./monitoring-stack
```

### Install the Chart

```bash
# Install in the monitoring namespace (will be created if it doesn't exist)
helm install monitoring-stack ./monitoring-stack --namespace monitoring --create-namespace
```

## Access Services

After installation, you can access the services:

### Grafana

```bash
# Get Grafana password
kubectl get secret --namespace monitoring monitoring-stack-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

# Port-forward Grafana service
kubectl port-forward --namespace monitoring svc/monitoring-stack-grafana 3000:80
```

Then access Grafana at http://localhost:3000

### Prometheus

```bash
kubectl port-forward --namespace monitoring svc/monitoring-stack-kube-prometheus-stack-prometheus 9090:9090
```

Then access Prometheus at http://localhost:9090

### AlertManager

```bash
kubectl port-forward --namespace monitoring svc/monitoring-stack-kube-prometheus-stack-alertmanager 9093:9093
```

Then access AlertManager at http://localhost:9093

## Configuration

See the [values.yaml](./values.yaml) file for configuration options.

## Upgrading

To upgrade the chart:

```bash
helm dependency update ./monitoring-stack
helm upgrade monitoring-stack ./monitoring-stack --namespace monitoring
```

## Uninstallation

To uninstall the chart:

```bash
helm uninstall monitoring-stack --namespace monitoring
```

Note: This will not remove the Persistent Volume Claims. To remove them:

```bash
kubectl delete pvc -l release=monitoring-stack -n monitoring
```