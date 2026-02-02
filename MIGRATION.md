# Migration Guide

## Migrating from GitHub Pages to GHCR OCI Registry

Starting from version 1.4.0, the universal chart is distributed via GitHub Container Registry (GHCR) as an OCI artifact instead of GitHub Pages.

### What Changed?

**Before (GitHub Pages):**
```bash
helm repo add okassov https://okassov.github.io/universal-chart
helm repo update
helm install my-release okassov/universal
```

**After (GHCR OCI):**
```bash
# No need to add repository
helm install my-release oci://ghcr.io/okassov/charts/universal --version 1.4.0
```

### Why This Change?

1. **No binary files in git** - Chart archives are no longer stored in the repository
2. **Better security** - OCI registries support image signing and verification
3. **Improved discovery** - Automatic indexing on Artifact Hub
4. **Simpler workflow** - No need to manage gh-pages branch
5. **Industry standard** - OCI is the modern standard for Helm charts (Helm 3.8+)

### Migration Steps

#### For Chart Users

1. **Remove old repository** (optional):
   ```bash
   helm repo remove okassov
   ```

2. **Install using OCI**:
   ```bash
   helm install my-release oci://ghcr.io/okassov/charts/universal --version 1.4.0
   ```

3. **Update existing deployments**:
   ```bash
   helm upgrade my-release oci://ghcr.io/okassov/charts/universal --version 1.4.0
   ```

#### For CI/CD Pipelines

**Before:**
```yaml
- name: Add Helm repository
  run: |
    helm repo add okassov https://okassov.github.io/universal-chart
    helm repo update

- name: Install chart
  run: helm install my-release okassov/universal --version 1.3.0
```

**After:**
```yaml
- name: Install chart
  run: helm install my-release oci://ghcr.io/okassov/charts/universal --version 1.4.0
```

#### For ArgoCD Users

**Before:**
```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
spec:
  source:
    repoURL: https://okassov.github.io/universal-chart
    chart: universal
    targetRevision: 1.3.0
```

**After:**
```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
spec:
  source:
    repoURL: ghcr.io
    chart: okassov/charts/universal
    targetRevision: 1.4.0
```

#### For Flux Users

**Before:**
```yaml
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: okassov
spec:
  url: https://okassov.github.io/universal-chart
  interval: 5m
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
spec:
  chart:
    spec:
      chart: universal
      sourceRef:
        kind: HelmRepository
        name: okassov
      version: 1.3.0
```

**After:**
```yaml
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: okassov
spec:
  type: oci
  url: oci://ghcr.io/okassov/charts
  interval: 5m
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
spec:
  chart:
    spec:
      chart: universal
      sourceRef:
        kind: HelmRepository
        name: okassov
      version: 1.4.0
```

### Requirements

- Helm 3.8.0 or later (for OCI support)
- Network access to ghcr.io

### Troubleshooting

#### Authentication Issues

If you encounter authentication errors:

```bash
# Login to GHCR (if accessing private charts)
echo $GITHUB_TOKEN | helm registry login ghcr.io -u USERNAME --password-stdin

# Pull the chart
helm pull oci://ghcr.io/okassov/charts/universal --version 1.4.0
```

#### Version Not Found

Make sure you're using the correct version:

```bash
# List available versions on GitHub
gh release list --repo okassov/universal-chart

# Or check Artifact Hub
# https://artifacthub.io/packages/helm/okassov/universal
```

### Support

If you encounter any issues during migration:

- [GitHub Issues](https://github.com/okassov/universal-chart/issues)
- [Discussions](https://github.com/okassov/universal-chart/discussions)

### Legacy Support

The GitHub Pages repository will remain accessible for existing versions (1.0.0 - 1.3.0) but will not receive updates. New versions (1.4.0+) will only be available via GHCR.
