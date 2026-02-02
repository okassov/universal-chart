# universal

![Version: 1.7.0](https://img.shields.io/badge/Version-1.7.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.7.0](https://img.shields.io/badge/AppVersion-1.7.0-informational?style=flat-square)
[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/universal-chart)](https://artifacthub.io/packages/search?repo=universal-chart)

Universal helm chart for business services

## Installation

### Using OCI Registry (Recommended)

The chart is available as an OCI artifact in GitHub Container Registry:

```bash
# Install the chart
helm install my-release oci://ghcr.io/okassov/charts/universal --version 1.7.0

# Install with custom values
helm install my-release oci://ghcr.io/okassov/charts/universal --version 1.7.0 -f values.yaml

# Upgrade
helm upgrade my-release oci://ghcr.io/okassov/charts/universal --version 1.7.0
```

### Using Helm Pull

```bash
# Download the chart
helm pull oci://ghcr.io/okassov/charts/universal --version 1.7.0

# Extract and install
tar -xzf universal-1.7.0.tgz
helm install my-release ./universal
```

### View on Artifact Hub

Visit [Artifact Hub](https://artifacthub.io/packages/search?repo=universal-chart) for more installation options and documentation.

## Monitoring and Alerting

This chart supports Prometheus Operator CRDs for metrics collection and custom alerting.

### Prerequisites

- [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack) or Prometheus Operator installed in your cluster
- ServiceMonitor and PrometheusRule CRDs available

### Enabling Metrics Collection

To enable Prometheus metrics scraping via ServiceMonitor:

```yaml
metrics:
  enabled: true
  path: /metrics
  port: ""  # Container port for metrics (optional, defaults to service port)

  service:
    port: 8081  # Service port for metrics endpoint

  serviceMonitor:
    enabled: true
    interval: 30s
    scrapeTimeout: 10s

    # IMPORTANT: Labels must match your Prometheus serviceMonitorSelector
    labels:
      release: prometheus-operator  # Adjust to your Prometheus release name
```

### Creating Custom Alerts

Define custom alerting rules using PrometheusRule CRD:

```yaml
metrics:
  enabled: true

  prometheusRule:
    enabled: true

    # IMPORTANT: Labels must match your Prometheus ruleSelector
    additionalLabels:
      release: prometheus-operator  # Adjust to your Prometheus release name
      role: alert-rules

    # Define multiple rule groups
    groups:
      # Application availability alerts
      - name: application-availability
        interval: 30s
        rules:
          - alert: HighErrorRate
            expr: |
              (
                sum(rate(http_requests_total{status=~"5.."}[5m]))
                /
                sum(rate(http_requests_total[5m]))
              ) > 0.05
            for: 5m
            labels:
              severity: critical
              component: api
            annotations:
              summary: "High HTTP 5xx error rate"
              description: "Error rate is {{ $value | humanizePercentage }} (threshold: 5%)"
              runbook_url: "https://runbooks.example.com/high-error-rate"

          - alert: ServiceDown
            expr: up == 0
            for: 2m
            labels:
              severity: critical
            annotations:
              summary: "Service is down"
              description: "{{ $labels.instance }} has been down for more than 2 minutes"

      # Performance alerts
      - name: application-performance
        rules:
          - alert: HighLatency
            expr: |
              histogram_quantile(0.95,
                sum(rate(http_request_duration_seconds_bucket[5m])) by (le)
              ) > 1
            for: 10m
            labels:
              severity: warning
            annotations:
              summary: "High request latency"
              description: "P95 latency is {{ $value }}s (threshold: 1s)"

      # Business metrics alerts
      - name: business-metrics
        interval: 1m
        rules:
          - alert: LowOrderRate
            expr: rate(orders_total[10m]) < 10
            for: 15m
            labels:
              severity: warning
              team: business
            annotations:
              summary: "Order rate is below threshold"
              description: "Current rate: {{ $value | humanize }} orders/sec"

          # Recording rule example
          - record: job:http_requests:rate5m
            expr: sum(rate(http_requests_total[5m])) by (job)
```

### Important Configuration Notes

#### 1. Label Selectors

For Prometheus Operator to discover your ServiceMonitor and PrometheusRule resources, their labels must match the selectors configured in your Prometheus CR.

**Find your Prometheus selectors:**

```bash
# Check serviceMonitorSelector
kubectl get prometheus -n monitoring -o jsonpath='{.items[0].spec.serviceMonitorSelector}'

# Check ruleSelector
kubectl get prometheus -n monitoring -o jsonpath='{.items[0].spec.ruleSelector}'
```

Common configurations:
- **kube-prometheus-stack**: `release: <your-prometheus-release-name>`
- **prometheus-operator**: `prometheus: kube-prometheus`

#### 2. Rule Group Organization

Organize your alerts into logical groups:
- **application-availability**: Uptime, error rates, health checks
- **application-performance**: Latency, throughput, resource usage
- **business-metrics**: Business KPIs, custom metrics, SLOs

Each group can have its own evaluation `interval`.

#### 3. Alert Severity Levels

Use consistent severity labels:
- `critical`: Requires immediate action, affects users
- `warning`: Should be addressed soon, potential issues
- `info`: Informational, no action required

#### 4. Annotations Best Practices

Include helpful context in annotations:
- `summary`: Short description of the alert
- `description`: Detailed information with templated values
- `runbook_url`: Link to remediation documentation
- `dashboard_url`: Link to relevant Grafana dashboard

### Complete Example

```yaml
metrics:
  enabled: true
  path: /metrics

  service:
    port: 8081

  serviceMonitor:
    enabled: true
    interval: 30s
    labels:
      release: prometheus-operator
    relabelings:
      - sourceLabels: [__meta_kubernetes_pod_node_name]
        targetLabel: node

  prometheusRule:
    enabled: true
    additionalLabels:
      release: prometheus-operator
      role: alert-rules
    groups:
      - name: my-app-alerts
        interval: 30s
        rules:
          - alert: HighErrorRate
            expr: rate(http_errors_total[5m]) > 0.05
            for: 5m
            labels:
              severity: critical
            annotations:
              summary: "High error rate detected"
              description: "Error rate: {{ $value | humanizePercentage }}"
```

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| file://charts/common | common | 0.x.x |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| args | list | `[]` |  |
| automountServiceAccountToken | bool | `false` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | string | `""` |  |
| autoscaling.minReplicas | string | `""` |  |
| autoscaling.targetCPU | string | `""` |  |
| autoscaling.targetMemory | string | `""` |  |
| clusterDomain | string | `"cluster.local"` |  |
| command | list | `[]` |  |
| commonAnnotations | object | `{}` |  |
| commonLabels | object | `{}` |  |
| configmap.annotations | object | `{}` |  |
| configmap.data | object | `{}` |  |
| configmap.enabled | bool | `false` |  |
| containerPorts[0].containerPort | int | `80` |  |
| containerPorts[0].name | string | `"http"` |  |
| containerPorts[0].protocol | string | `"TCP"` |  |
| containerPorts[1].containerPort | int | `8443` |  |
| containerPorts[1].name | string | `"https"` |  |
| containerPorts[1].protocol | string | `"TCP"` |  |
| containerSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| containerSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| containerSecurityContext.enabled | bool | `false` |  |
| containerSecurityContext.privileged | bool | `false` |  |
| containerSecurityContext.readOnlyRootFilesystem | bool | `true` |  |
| containerSecurityContext.runAsGroup | int | `1001` |  |
| containerSecurityContext.runAsNonRoot | bool | `true` |  |
| containerSecurityContext.runAsUser | int | `1001` |  |
| containerSecurityContext.seLinuxOptions | object | `{}` |  |
| containerSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| dnsConfig | object | `{}` |  |
| dnsPolicy | string | `""` |  |
| env | list | `[]` |  |
| envFrom | list | `[]` |  |
| extraDeploy | list | `[]` |  |
| fullnameOverride | string | `""` |  |
| global.compatibility.openshift.adaptSecurityContext | string | `"auto"` |  |
| global.imagePullSecrets | list | `[]` |  |
| global.imageRegistry | string | `""` |  |
| hostAliases | list | `[]` |  |
| hostIPC | bool | `false` |  |
| hostNetwork | bool | `false` |  |
| image.digest | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.pullSecrets | list | `[]` |  |
| image.registry | string | `"docker.io"` |  |
| image.repository | string | `"hello-world"` |  |
| image.tag | string | `"latest"` |  |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| initContainers | list | `[]` |  |
| kubeVersion | string | `""` |  |
| lifecycleHooks | object | `{}` |  |
| livenessProbe | object | `{}` |  |
| metrics.enabled | bool | `false` |  |
| metrics.path | string | `"/metrics"` |  |
| metrics.port | string | `""` |  |
| metrics.prometheusRule.additionalLabels | object | `{}` |  |
| metrics.prometheusRule.enabled | bool | `false` |  |
| metrics.prometheusRule.groups | list | `[]` |  |
| metrics.prometheusRule.namespace | string | `""` |  |
| metrics.service.annotations."prometheus.io/path" | string | `"/metrics"` |  |
| metrics.service.annotations."prometheus.io/port" | string | `"8081"` |  |
| metrics.service.annotations."prometheus.io/scrape" | string | `"true"` |  |
| metrics.service.port | int | `8081` |  |
| metrics.serviceMonitor.enabled | bool | `false` |  |
| metrics.serviceMonitor.honorLabels | bool | `false` |  |
| metrics.serviceMonitor.interval | string | `""` |  |
| metrics.serviceMonitor.jobLabel | string | `""` |  |
| metrics.serviceMonitor.labels | object | `{}` |  |
| metrics.serviceMonitor.metricRelabelings | list | `[]` |  |
| metrics.serviceMonitor.namespace | string | `""` |  |
| metrics.serviceMonitor.relabelings | list | `[]` |  |
| metrics.serviceMonitor.scrapeTimeout | string | `""` |  |
| metrics.serviceMonitor.selector | object | `{}` |  |
| nameOverride | string | `""` |  |
| namespaceOverride | string | `""` |  |
| networkPolicy.allowExternal | bool | `true` |  |
| networkPolicy.allowExternalEgress | bool | `true` |  |
| networkPolicy.enabled | bool | `false` |  |
| networkPolicy.extraEgress | list | `[]` |  |
| networkPolicy.extraIngress | list | `[]` |  |
| networkPolicy.ingressNSMatchLabels | object | `{}` |  |
| networkPolicy.ingressNSPodMatchLabels | object | `{}` |  |
| nodeAffinityPreset.key | string | `""` |  |
| nodeAffinityPreset.type | string | `""` |  |
| nodeAffinityPreset.values | list | `[]` |  |
| nodeSelector | object | `{}` |  |
| pdb.create | bool | `false` |  |
| pdb.maxUnavailable | string | `""` |  |
| pdb.minAvailable | string | `""` |  |
| podAffinityPreset | string | `""` |  |
| podAnnotations | object | `{}` |  |
| podAntiAffinityPreset | string | `"soft"` |  |
| podLabels | object | `{}` |  |
| podSecurityContext.enabled | bool | `false` |  |
| podSecurityContext.fsGroup | int | `1001` |  |
| podSecurityContext.fsGroupChangePolicy | string | `"Always"` |  |
| podSecurityContext.supplementalGroups | list | `[]` |  |
| podSecurityContext.sysctls | list | `[]` |  |
| priorityClassName | string | `""` |  |
| readinessProbe | object | `{}` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| resourcesPreset | string | `"nano"` |  |
| revisionHistoryLimit | int | `10` |  |
| schedulerName | string | `""` |  |
| service.annotations | object | `{}` |  |
| service.clusterIP | string | `""` |  |
| service.enabled | bool | `true` |  |
| service.externalTrafficPolicy | string | `"Cluster"` |  |
| service.loadBalancerClass | string | `""` |  |
| service.loadBalancerIP | string | `""` |  |
| service.loadBalancerSourceRanges | list | `[]` |  |
| service.ports[0].name | string | `"http"` |  |
| service.ports[0].port | int | `80` |  |
| service.ports[0].protocol | string | `"TCP"` |  |
| service.ports[0].targetPort | string | `"http"` |  |
| service.ports[1].name | string | `"https"` |  |
| service.ports[1].port | int | `443` |  |
| service.ports[1].protocol | string | `"TCP"` |  |
| service.ports[1].targetPort | string | `"https"` |  |
| service.sessionAffinity | string | `"None"` |  |
| service.sessionAffinityConfig | object | `{}` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automountServiceAccountToken | bool | `false` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| sidecarSingleProcessNamespace | bool | `false` |  |
| sidecars | list | `[]` |  |
| startupProbe | object | `{}` |  |
| terminationGracePeriodSeconds | string | `""` |  |
| tolerations | list | `[]` |  |
| topologySpreadConstraints | list | `[]` |  |
| updateStrategy.rollingUpdate | object | `{}` |  |
| updateStrategy.type | string | `"RollingUpdate"` |  |
| volumeMounts | list | `[]` |  |
| volumes | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
