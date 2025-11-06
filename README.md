# universal

![Version: 1.1.0](https://img.shields.io/badge/Version-1.1.0-informational?style=flat-square) ![AppVersion: 1.1.0](https://img.shields.io/badge/AppVersion-1.1.0-informational?style=flat-square)

Universal helm chart for business services

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
| containerPorts | list | `[{"containerPort":80,"name":"http","protocol":"TCP"},{"containerPort":8443,"name":"https","protocol":"TCP"}]` | Array of container ports with name, containerPort and protocol |
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
| extraDeploy | list | `[]` |  |
| env | list | `[]` | Environment variables to be set on server containers. Supports both simple values and valueFrom references. |
| envFrom | list | `[]` | List of sources to populate environment variables. Supports multiple ConfigMaps and Secrets. |
| extraVolumeMounts | list | `[]` |  |
| extraVolumes | list | `[]` |  |
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
| ingress.apiVersion | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.extraHosts | list | `[]` |  |
| ingress.extraPaths | list | `[]` |  |
| ingress.extraRules | list | `[]` |  |
| ingress.extraTls | list | `[]` |  |
| ingress.hostname | string | `"example.local"` |  |
| ingress.ingressClassName | string | `""` |  |
| ingress.path | string | `"/"` |  |
| ingress.pathType | string | `"ImplementationSpecific"` |  |
| initContainers | list | `[]` |  |
| kubeVersion | string | `""` |  |
| lifecycleHooks | object | `{}` |  |
| livenessProbe | object | `{}` |  |
| metrics.enabled | bool | `false` |  |
| metrics.port | string | `""` |  |
| metrics.prometheusRule.additionalLabels | object | `{}` |  |
| metrics.prometheusRule.enabled | bool | `false` |  |
| metrics.prometheusRule.namespace | string | `""` |  |
| metrics.prometheusRule.rules | list | `[]` |  |
| metrics.service.annotations."prometheus.io/path" | string | `"/metrics"` |  |
| metrics.service.annotations."prometheus.io/port" | string | `"{{ .Values.metrics.service.port }}"` |  |
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
| service.ports | list | `[{"name":"http","port":80,"protocol":"TCP","targetPort":"http"},{"name":"https","port":443,"protocol":"TCP","targetPort":"https"}]` | Array of service ports with name, port, targetPort, protocol and optional nodePort |
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

## Ports Configuration

Starting from version 1.1.0, the chart uses a flexible array-based approach for configuring ports instead of hardcoded `http` and `https` parameters.

### Container Ports

The `containerPorts` parameter allows you to define any number of container ports with custom names and protocols:

```yaml
containerPorts:
  - name: http
    containerPort: 8080
    protocol: TCP
  - name: grpc
    containerPort: 9090
    protocol: TCP
  - name: metrics
    containerPort: 9091
    protocol: TCP
  - name: udp-service
    containerPort: 5000
    protocol: UDP
```

### Service Ports

The `service.ports` parameter provides full control over service port configuration, including `nodePort` for NodePort/LoadBalancer services:

```yaml
service:
  type: LoadBalancer
  ports:
    - name: http
      port: 80
      targetPort: http
      protocol: TCP
      nodePort: 30080  # optional, only for NodePort/LoadBalancer
    - name: grpc
      port: 9090
      targetPort: grpc
      protocol: TCP
    - name: metrics
      port: 9091
      targetPort: metrics
      protocol: TCP
```

### Complete Example

```yaml
containerPorts:
  - name: web
    containerPort: 8080
    protocol: TCP
  - name: grpc
    containerPort: 9090
    protocol: TCP
  - name: admin
    containerPort: 8081
    protocol: TCP

service:
  enabled: true
  type: NodePort
  ports:
    - name: web
      port: 80
      targetPort: web
      protocol: TCP
      nodePort: 30080
    - name: grpc
      port: 9090
      targetPort: grpc
      protocol: TCP
      nodePort: 30090
    - name: admin
      port: 8081
      targetPort: admin
      protocol: TCP
```

**Benefits:**
- Support for any number of ports
- TCP and UDP protocols
- Flexible port naming
- Integrated nodePort configuration
- No need for separate `extraContainerPorts` or `extraPorts` parameters

## Environment Variables Configuration

### Using `env` parameter

The `env` parameter allows you to define environment variables in multiple ways:

#### Simple environment variables:
```yaml
env:
  - name: FOO
    value: "bar"
  - name: APP_ENV
    value: "production"
```

#### Using valueFrom to reference secrets or configmaps:
```yaml
env:
  - name: DATABASE_PASSWORD
    valueFrom:
      secretKeyRef:
        name: db-credentials
        key: password
  - name: API_KEY
    valueFrom:
      secretKeyRef:
        name: api-secrets
        key: api-key
  - name: CONFIG_VALUE
    valueFrom:
      configMapKeyRef:
        name: app-config
        key: some-value
```

### Using `envFrom` parameter

The `envFrom` parameter allows you to import all key-value pairs from ConfigMaps and Secrets as environment variables. You can specify multiple sources:

```yaml
envFrom:
  - configMapRef:
      name: app-config
  - secretRef:
      name: app-secrets
  - configMapRef:
      name: shared-config
  - secretRef:
      name: database-credentials
```

### Combined usage

You can use both `env` and `envFrom` together:

```yaml
env:
  - name: SPECIFIC_VAR
    value: "specific-value"
  - name: SECRET_TOKEN
    valueFrom:
      secretKeyRef:
        name: tokens
        key: token

envFrom:
  - configMapRef:
      name: common-config
  - secretRef:
      name: common-secrets
```

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
