## Install & Configure cert-manager

### Pre-requisites

1. An ibm container services cluster
2. Helm installed on the cluster

### Install cert-manager

1. Issue the following command:

```
helm install \
    --name cert-manager \
    --namespace kube-system \
    stable/cert-manager
```

2. Create a cluster issuer. The examples in this repo currently assume the following cluster.yaml file

**NOTE:** Be sure to replace your-email with your actual e-mail

```
apiVersion: certmanager.k8s.io/v1alpha1
kind: ClusterIssuer
metadata:
  name: letsencrypt-staging-cluster-issuer
spec:
  acme:
    server: https://acme-staging.api.letsencrypt.org/directory
    email: your-email
    privateKeySecretRef:
      name: letsencrypt-staging
    http01: {}
```

3. Install this on your cluster with kubectl

```
kubectl apply --namespace=[namespace] -f cluster.yaml
```

4. Certificates that reference this cluster issuer should now work. This uses a Cluster issuer which can work with any namespace on this cluster.