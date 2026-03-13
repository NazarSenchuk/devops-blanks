# Kubernetes Security Checklist

## 1. Authentication and Authorization
- [ ] **Implement an Identity Provider (IdP):** Use an IdP server (e.g., via OIDC) for user authentication to the API rather than service account tokens.
- [ ] **Enforce RBAC:** Develop a Role-Based Access Control model for every cluster and assign rights based on the principle of least privilege and separation of duties.
- [ ] **Personalize Accounts:** Ensure user accounts are personalized and service accounts have unique, descriptive names reflecting their purpose.
- [ ] **Restrict Access:** Disable anonymous authentication (except for health checks) and prohibit user impersonation.
- [ ] **Secure Admin Access:** Use privileged access management systems (like Teleport or Boundary) for administrators interacting with the API or infrastructure.

## 2. Cluster and Host Configuration
- [ ] **Encryption:** Use TLS encryption between all cluster components.
- [ ] **Policy Engines:** Deploy a policy engine (such as Kyverno, OPA, or jsPolicy) to automate and enforce security requirements.
- [ ] **Compliance:** Follow CIS Kubernetes Benchmarks for configuration and keep all cluster components updated to the latest versions to mitigate known CVEs.
- [ ] **OS Hardening:** Configure the underlying OS according to CIS or NIST standards, scan for vulnerabilities regularly, and keep the kernel updated.
- [ ] **High Isolation:** For sensitive services, consider using low-level runtimes with high isolation, such as gVisor or Kata-runtime.

## 3. Network Security
- [ ] **Namespace Isolation:** Ensure all namespaces have a NetworkPolicy that limits interactions according to least privilege.
- [ ] **Internal Traffic:** Use authentication and authorization (e.g., via a service mesh like Istio or Linkerd) between microservices.
- [ ] **Edge Security:** Do not publish cluster component interfaces on the internet, and use a WAF to inspect external user traffic.
- [ ] **Segmentation:** Isolate the control plane, data storage, and internet-facing nodes (DMZ) into separate VLANs.

## 4. Secrets Management
- [ ] **Secure Storage:** Store secrets in third-party tools like HashiCorp Vault or ensure etcd is encrypted.
- [ ] **Safe Injection:** Use `volumeMount` or `secretKeyRef` to add secrets to containers; never store them in source code or Dockerfiles.

## 5. Workload Hardening (Pod Security Standards)
> [!NOTE]
> Implement Pod Security Standards (PSS) through the Pod Security Admission (PSA) controller, which can Enforce, Audit, or Warn based on policy levels.

- [ ] **No Root Access:** Do not run pods under the root account (UID 0); explicitly set `runAsNonRoot: true` and use non-zero values for `runAsUser`.
- [ ] **Privilege Control:** Set `allowPrivilegeEscalation: false` and prohibit the use of the `privileged: true` flag.
- [ ] **Restrict Namespaces:** Disallow pods from sharing the host namespace (`hostPID`, `hostIPC`, `hostNetwork`).
- [ ] **Limit Volumes:** Forbidden the use of `hostPath` volumes.
- [ ] **Capabilities:** Drop `ALL` Linux capabilities by default and only add back essential ones (e.g., `NET_BIND_SERVICE`), avoiding dangerous ones like `CAP_SYS_ADMIN`.
- [ ] **Security Profiles:** Apply AppArmor, SELinux, or Seccomp (`RuntimeDefault`) profiles to all workloads.
- [ ] **Resource Management:** Set CPU and RAM limits for all containers and use a read-only root filesystem where possible.

## 6. Image Development and Supply Chain
- [ ] **Minimalism:** Use multi-stage builds and minimal base images that exclude unnecessary tools like `curl` or `sudo`.
- [ ] **Tagging:** Avoid the `latest` tag; explicitly indicate package and image versions.
- [ ] **Scanning and Signing:** Automatically scan images (e.g., Trivy) and Dockerfiles (e.g., Hadolint) during development. Generate and verify image signatures before deployment.

## 7. Audit, Logging, and Monitoring
- [ ] **Centralized Logging:** Send all security events, access changes, and secret operations to a centralized SIEM located outside the cluster.
- [ ] **Runtime Monitoring:** Use third-party tools (like Falco or Sysdig) on all nodes to detect suspicious activity in real-time.
- [ ] **Regular Audits:** Periodically audit RBAC rights, cluster configurations, and workload settings using tools like KubiScan, Kube-bench, or Kubescape.
