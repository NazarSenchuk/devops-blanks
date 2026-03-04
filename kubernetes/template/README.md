# Kubernetes Kustomize Project

This repository follows a scalable Kustomize structure for managing multiple applications across environments.

- `bases/`: Per‑application base manifests
- `overlays/`: Environment-specific overlays (dev, test, prod)
- `cluster/`: Cluster-wide resources (namespaces, CRDs, storage classes)
- `charts/`: Helm charts (if used)
- `scripts/`: Helper scripts
- `ci-cd/`: Pipeline definitions
- `templates/`: Jinja/Jsonnet templates (optional)
