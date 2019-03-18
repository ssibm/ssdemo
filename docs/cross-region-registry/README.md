# Cross Region Image Pull

### Objective: Pull an image from a container registry located in another region.

### Prerequisites
- [IBM Cloud CLI](https://console.bluemix.net/docs/cli/index.html#overview)
- [IBM Cloud CLI container registry plugin](https://console.bluemix.net/docs/services/Registry/index.html#index)
- [Kubernetes CLI](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

## Instructions

1. In order to pull an image from another region, you will need to create a container registry token for that region. You can do this through the IBM Cloud CLI. First, log in to IBM Cloud with sso.

  ```
  ibmcloud login --sso
  ```

2. Now, you will need to set up the container registry plugin to point to the region that the container registry with the image you're pulling is stored.

  ```
  ibmcloud cr login
  ibmcloud cr region-set
  ```

  The `region-set` command will prompt you to select a region.

3. Create a token from the container registry region that you just set.

  ```
  ibmcloud cr token-add --description "<description>" --non-expiring -q
  ```

  You will receive a token outputted to the terminal. Copy it as you will need it in the upcoming steps.

4. Next, create a secret in your kubernetes cluster namespace where you will be pulling the image to.

  ```
  kubectl --namespace <kubernetes_namespace> create secret docker-registry <secret_name>  --docker-server=<registry_url> --docker-username=token --docker-password=<token_value> --docker-email <email>
  ```

  - `<kubernetes_namespace>`: the namespace on your cluster you're pulling the image to.
  - `<secret_name>`: name your secret something easily identifiable.
  - `<registry_url>`: the URL of the registry that the token is from. You set this in step 2 above.
  - `<token_value>`: the token you just received in the previous step.
  - `<email>`: required, but not used after secret creation.

5. The secret has been created, but it needs to be added to your default `serviceaccount` in order to be used during deployment.

  ```
  kubectl patch serviceaccount default -p '{"imagePullSecrets": [{"name": "<secret_name>"}]}' --namespace <kubernetes_namespace>
  ```

  For `<kubernetes_namespace>` and `<secret_name>`, have it the same as in the previous step.

And voila! You should now be able to pull images cross region from the container registry that you created a token from in your cluster namespace.

### Helpful Links
- https://console.bluemix.net/docs/containers/cs_dedicated_tokens.html
