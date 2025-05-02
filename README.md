# Prometheus and Grafana for Kubernetes

This repository contains a Helm chart for deploying a complete Kubernetes monitoring stack including Prometheus, Grafana, Alertmanager, and Loki for log aggregation.

## What's Included

- **Prometheus**: Time series database for metrics storage and alerting
- **Grafana**: Visualization and dashboarding platform
- **Alertmanager**: Handles alerts sent by Prometheus and routes them to receivers
- **Node Exporter**: Collects hardware and OS metrics from Kubernetes nodes
- **kube-state-metrics**: Generates metrics about the state of Kubernetes objects
- **Loki**: Log aggregation system similar to Prometheus but for logs
- **Promtail**: Agent that ships logs to Loki

## Repository Structure

- **[monitoring-stack/](./monitoring-stack/)**: Helm chart for the monitoring stack
  - **charts/**: Contains downloaded dependency charts
  - **templates/**: Contains Kubernetes manifest templates
  - **examples/**: Contains example configuration files
  - **values.yaml**: Default configuration values
  - **values-production.yaml**: Production-ready configuration values

## Getting Started

### Prerequisites

- Kubernetes 1.16+
- Helm 3.0+
- Persistent volume provisioner support in your cluster
- Storage class capable of provisioning persistent volumes

### Installation Steps

1. **Clone this repository**:
   ```bash
   git clone [YOUR-REPO-URL]
   cd Prometheus
   ```

2. **Update Helm chart dependencies**:
   ```bash
   cd monitoring-stack
   helm dependency update
   ```

3. **Install the chart**:
   ```bash
   # For development/testing environments:
   helm install monitoring-stack ./monitoring-stack --namespace monitoring --create-namespace

   # For production environments:
   helm install monitoring-stack ./monitoring-stack -f ./monitoring-stack/values-production.yaml --namespace monitoring --create-namespace
   ```

4. **Access the services**:
   Follow the instructions in the [monitoring-stack README](./monitoring-stack/README.md) to access Grafana, Prometheus, and other services.

## Customization

You can customize the deployment by modifying either:
- **values.yaml**: For minor tweaks and configurations
- **values-production.yaml**: For production-ready settings

### Common Customizations

#### Storage Classes

If your cluster uses different storage classes, update the `storageClassName` fields:

```yaml
prometheus:
  prometheusSpec:
    storageSpec:
      volumeClaimTemplate:
        spec:
          storageClassName: your-storage-class
```

#### Resource Limits

Adjust the resource limits and requests based on your cluster capacity:

```yaml
prometheus:
  prometheusSpec:
    resources:
      requests:
        memory: 1Gi
        cpu: 200m
      limits:
        memory: 2Gi
        cpu: 500m
```

#### Retention Period

Change how long Prometheus keeps data:

```yaml
prometheus:
  prometheusSpec:
    retention: 15d  # 15 days retention
```

## Monitoring Your Applications

To monitor your own applications:

1. Make your application expose Prometheus metrics (typically on `/metrics`)
2. Create a ServiceMonitor resource like in [service-monitor-example.yaml](./monitoring-stack/examples/service-monitor-example.yaml)

## Upgrading

To upgrade the monitoring stack:

```bash
cd monitoring-stack
helm dependency update
helm upgrade monitoring-stack ./monitoring-stack --namespace monitoring
```

## Troubleshooting

### Common Issues

- **PVC Creation Failure**: Ensure your cluster has a default storage class or specify one
- **Resource Constraints**: If pods are failing to start, check if your nodes have sufficient resources
- **Service Discovery Issues**: Ensure labels match between ServiceMonitors and your services
- **Permission Issues**: The stack requires certain RBAC permissions for collecting cluster metrics

## Additional Resources

- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/)
- [kube-prometheus-stack Chart Documentation](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)
- [Loki Documentation](https://grafana.com/docs/loki/latest/)