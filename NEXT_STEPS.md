# 🚀 Next Steps for GHCR OCI Migration

## ✅ What We've Done

1. ✅ Updated `.github/workflows/release.yml` to publish to GHCR OCI
2. ✅ Added Artifact Hub metadata to `Chart.yaml`
3. ✅ Created `artifacthub-repo.yml` for repository configuration
4. ✅ Created `README.md.gotmpl` template with installation instructions
5. ✅ Updated `.gitignore` to exclude `.tgz` files
6. ✅ Created `MIGRATION.md` for users
7. ✅ Added security scanning workflow (optional)

## 🎯 What You Need to Do

### 1. Regenerate README (if you have helm-docs installed)

```bash
# Install helm-docs if needed
brew install norwoodj/tap/helm-docs
# or
go install github.com/norwoodj/helm-docs/cmd/helm-docs@latest

# Generate updated README
helm-docs

# Review the changes
git diff README.md
```

### 2. Update Chart Version

Bump the version for the first GHCR release:

```bash
# Edit Chart.yaml and charts/common/Chart.yaml
# Change version from 1.3.0 to 1.4.0

# Update the changelog annotation in Chart.yaml
```

**Chart.yaml:**
```yaml
version: 1.4.0
appVersion: 1.4.0

annotations:
  artifacthub.io/changes: |
    - kind: changed
      description: Migrated to GHCR OCI registry for chart distribution
    - kind: changed
      description: Simplified volumes configuration by removing extra prefix
    - kind: added
      description: Support for all Kubernetes volume types
```

### 3. Commit and Push Changes

```bash
# Stage all changes
git add .

# Commit
git commit -m "feat: migrate to GHCR OCI registry (v1.4.0)

- Publish charts to ghcr.io instead of GitHub Pages
- Add Artifact Hub metadata
- Add migration guide for users
- Add security scanning workflow
- Update installation documentation

BREAKING CHANGE: Chart repository URL has changed from
https://okassov.github.io/universal-chart to
oci://ghcr.io/okassov/charts/universal
"

# Push to main
git push origin main
```

### 4. Create Release Tag

```bash
# Create and push tag
git tag -a 1.4.0 -m "Release v1.4.0 - GHCR OCI migration"
git push origin 1.4.0
```

This will trigger the release workflow and publish to GHCR!

### 5. Verify GHCR Publication

After the workflow completes:

1. **Check GitHub Packages:**
   - Go to https://github.com/okassov?tab=packages
   - You should see `charts/universal` package

2. **Test Installation:**
   ```bash
   helm pull oci://ghcr.io/okassov/charts/universal --version 1.4.0
   ```

3. **Make Package Public:**
   - Go to package settings
   - Change visibility to "Public"
   - Link to repository

### 6. Register on Artifact Hub

1. **Sign Up/Login:**
   - Go to https://artifacthub.io/
   - Sign in with GitHub

2. **Add Repository:**
   - Click "Add Repository"
   - Select "Helm charts" type
   - Choose "OCI Registry"
   - Enter repository URL: `oci://ghcr.io/okassov/charts/universal`
   - Click "Add"

3. **Wait for Indexing:**
   - Artifact Hub will automatically discover and index your chart
   - This may take a few minutes

4. **Update artifacthub-repo.yml:**
   - After repository is created, you'll get a `repositoryID`
   - Add it to `artifacthub-repo.yml`

### 7. Update Repository README

Add badges to your repository README:

```markdown
# universal

[![Release](https://img.shields.io/github/v/release/okassov/universal-chart)](https://github.com/okassov/universal-chart/releases)
[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/universal)](https://artifacthub.io/packages/helm/okassov/universal)
[![License](https://img.shields.io/github/license/okassov/universal-chart)](LICENSE)

Universal helm chart for business services

## Installation

\`\`\`bash
helm install my-release oci://ghcr.io/okassov/charts/universal --version 1.4.0
\`\`\`

For migration from GitHub Pages, see [MIGRATION.md](MIGRATION.md).
```

### 8. Clean Up (Optional)

After verifying everything works:

```bash
# Delete gh-pages branch (keeps it in history for old versions)
git push origin --delete gh-pages

# Update repository description and topics on GitHub
# Topics: helm, kubernetes, helm-chart, oci, kubernetes-deployment
```

### 9. Announce Migration

Create a GitHub Discussion or issue:

**Title:** "📢 Chart Repository Migration to GHCR OCI"

**Content:**
```markdown
Starting from version 1.4.0, the universal chart is distributed via GitHub Container Registry (GHCR) as an OCI artifact.

**New Installation:**
\`\`\`bash
helm install my-release oci://ghcr.io/okassov/charts/universal --version 1.4.0
\`\`\`

**Benefits:**
- No need to add Helm repository
- Better security and verification
- Automatic indexing on Artifact Hub
- Simpler CI/CD integration

**Migration Guide:** See [MIGRATION.md](MIGRATION.md)

**Legacy versions (1.0.0-1.3.0)** remain available via GitHub Pages for existing users.
```

## 🎉 Success Checklist

- [ ] README regenerated with helm-docs
- [ ] Version bumped to 1.4.0
- [ ] Changes committed and pushed
- [ ] Tag 1.4.0 created and pushed
- [ ] GitHub Actions workflow completed successfully
- [ ] Chart visible in GitHub Packages
- [ ] Package set to public visibility
- [ ] Chart installable via `helm pull oci://`
- [ ] Registered on Artifact Hub
- [ ] Repository README updated with badges
- [ ] Migration announced to users
- [ ] gh-pages branch deleted (optional)

## 📚 Resources

- [Helm OCI Support](https://helm.sh/docs/topics/registries/)
- [Artifact Hub Documentation](https://artifacthub.io/docs/)
- [GHCR Documentation](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)

## 🆘 Troubleshooting

If you encounter issues:

1. **Workflow fails:** Check GitHub Actions logs
2. **Can't pull chart:** Verify package is public
3. **Artifact Hub not indexing:** Check `artifacthub-repo.yml` and repository visibility

Feel free to reach out if you need help!
