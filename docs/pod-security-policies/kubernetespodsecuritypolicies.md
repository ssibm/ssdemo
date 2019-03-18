 # Kubernetes - Pod Security Policies
 
Objects of type ```PodSecurityPolicy``` govern the ability to make requests on a pod that affect the ```SecurityContext``` that will be applied to a pod and container. Pod Security Policies are comprised of settings and strategies that control the security features a pod has access to. ```PodSecurityPolicy``` works more like a firewall - though it is **important** to note that it is **`NOT`** a hardware firewall device or a software firewall in Kubernetes. 
 
 ## What is a Pod Security Policy?
 
A Pod Security Policy is a cluster-level resource that controls the actions that a pod can perform and what it has the ability to access. The ```PodSecurityPolicy``` objects define a set of conditions that a pod must run with in order to be accepted into the system. They allow an administrator to control the following:
 
<img width="842" alt="image" src="https://media.github.ibm.com/user/20538/files/832a8ecc-8ec4-11e8-89c5-758433574e00">
 
By default, the cluster contains the following RBAC resources that enable cluster administrators, authenticated users, service accounts, and nodes to use the ```ibm-privileged-psp``` and ```ibm-restricted-psp``` pod security policies. These policies allow the users to create and update privileged and unprivileged (restricted) pods.

<img width="749" alt="image" src="https://media.github.ibm.com/user/20538/files/0c8d4e5a-8ec7-11e8-916b-f32d9fef0dfe">

The Kubernetes cluster in IBM Cloud Kubernetes Service contains the following pod security policies and related RBAC resources to allow IBM to properly manage your cluster. The default ```privileged-psp-user``` and ```restricted-psp-user``` RBAC resources refer to the pod security policies that are set by IBM. 
 
<img width="681" alt="image" src="https://media.github.ibm.com/user/20538/files/a9ea3828-8ec4-11e8-9c41-6d38fb75528e">

## Creating a Pod Security Policy

Here is an example of a Pod Security Policy. In this example, let’s prevent everyone except the cluster administrator from creating a privileged container in the default namespace.

<img width="90" alt="image" src="https://media.github.ibm.com/user/20538/files/deb2fa12-89c0-11e8-94bd-986b06b7bd99">

It is **`NOT`** recommended to perfrom these test cases in a production cluster

## Test Case 1

### Setup

1. Start by downloading and using the Kubernetes configuration for your cluster:

**$(bx cs cluster-config <cluster name or ID> | grep export)**

Output:

<img width="531" alt="image" src="https://media.github.ibm.com/user/20538/files/b92000b0-8849-11e8-98e1-e690ae25b8c4">

(The *.yaml* file used in this portion of the case is called `privileged-psp-user.yaml` and can be viewed and downloaded [here](https://github.ibm.com/customer-success/swarm/tree/master/pod-security-policies/yamlfiles).)

2. Save a backup to restore later: 

**kubectl get clusterrolebinding privileged-psp-user -o yaml > privileged-psp-user.yaml**

Output:

<img width="878" alt="image" src="https://media.github.ibm.com/user/20538/files/9859957a-884a-11e8-9b18-0208400ff1d5">

<img width="1040" alt="image" src="https://media.github.ibm.com/user/20538/files/983fdba0-8852-11e8-955f-760c68334369">

3. Run **kubectl edit clusterrolebinding privileged-psp-user** and remove all **subjects** entries except for the **system:masters** entry. This will prevent everyone from creating privileged containers except cluster administrators.
(The modified *.yaml* file used in this portion of the case is called `masters.yaml` and can be viewed and downloaded [here](https://github.ibm.com/customer-success/swarm/tree/master/pod-security-policies/yamlfiles).)

Output:

<img width="643" alt="image" src="https://media.github.ibm.com/user/20538/files/75eedf74-894c-11e8-9325-89c99f29dfcf">

### Successful pod creation

Create a privileged container via a Pod.  This should succeed.

```
kubectl apply -f - << EOF
apiVersion: v1
kind: Pod
metadata:
  name: privileged
spec:
  containers:
  - name: privileged
    image: k8s.gcr.io/pause:3.1
    securityContext:
      privileged: true
EOF
```
Output:

<img width="460" alt="image" src="https://media.github.ibm.com/user/20538/files/d0ddb9fa-8852-11e8-8feb-f19a85e81c22">

Now run **kubectl get pods**.  You will see the privileged container running.

Output:

<img width="397" alt="image" src="https://media.github.ibm.com/user/20538/files/f1148316-8852-11e8-8841-9ade62dcb9cf">

### Failed pod creation

First run **kubectl delete pod privileged** to delete the pod. Then create a privileged container via a **Deployment**.  This should succeed.
```
kubectl apply -f - << EOF
apiVersion: apps/v1beta2
kind: Deployment
metadata:
  labels:
    run: privileged
  name: privileged
spec:
  selector:
    matchLabels:
      run: privileged
  template:
    metadata:
      labels:
        run: privileged
    spec:
      containers:
      - name: privileged
        image: k8s.gcr.io/pause:3.1
        securityContext:
          privileged: true
EOF
```
Output:

<img width="457" alt="image" src="https://media.github.ibm.com/user/20538/files/2af07158-8853-11e8-8157-4aa2c0d1fdd7">

Run **kubectl get pods**.  You will see nothing.  So what happened?

Output:

<img width="399" alt="image" src="https://media.github.ibm.com/user/20538/files/41948278-8853-11e8-9d43-e7d06c038d70">

Kubernetes used the **default** service account credentials in the **default** namespace when creating the pod, not your credentials.  Run **kubectl get events | grep FailedCreate**.  You will see that pod creation was **forbidden** because the service account was not authorized to any pod security policies allowing creation of a privileged container.

### Fix pod creation

Run **kubectl edit clusterrolebinding privileged-psp-user** and add a **subjects** entry for **system:serviceaccounts**. (The modified *.yaml* file used in this portion of the case is called `serviceaccounts.yaml` and can be viewed and downloaded [here](https://github.ibm.com/customer-success/swarm/tree/master/pod-security-policies/yamlfiles).)

Output:

<img width="646" alt="image" src="https://media.github.ibm.com/user/20538/files/0f2b1e74-894c-11e8-86d5-5a0188fb3fa3">

This will authorize all service accounts in all namespace to create a privileged container.  Now run **kubectl get pods** again, and after a minute or two, you will see the privileged container running. 

Output:

<img width="469" alt="image" src="https://media.github.ibm.com/user/20538/files/686d3aca-894d-11e8-909f-63f4ccd556fc">

When you create a pod by using a resource controller such as a deployment, Kubernetes validates the pod’s service account credentials against the pod security policies that the service account is authorized to use.

### Cleanup

1. Run **kubectl delete deployment privileged** to delete the deployment.
2. Restore your backup: **kubectl apply --force=true -f privileged-psp-user.yaml**

## Test Case 2

### Set up

1. First back up your clusterrolebinding (so you can re-create it later):

**kubectl get clusterrolebinding privileged-psp-user -o yaml > privileged_clr.yaml**

2. Assuming you already have a Docker image for `nginx` in your namespace run the following command: 

**kubectl apply -f nginx.yaml**

Output:

<img width="473" alt="image" src="https://media.github.ibm.com/user/20538/files/aa2d711c-89bd-11e8-9d30-b150c1e30335">

3. Run the **kubectl get po,deploy** to view current deplyments

Output:

<img width="662" alt="image" src="https://media.github.ibm.com/user/20538/files/00b92cba-89be-11e8-91b0-eec14afd0f8d">

Deployments have not started - attempting to create deployments, with privileged pods, the deployment will be **successful**, but the pods will not actually start.

4. Run the command: **kubectl describe pod/nginx-deployment-5c66cd676c-5k544** (your deployment name in your cluster may have different name) to view details of your pending deployment.

Output:

<img width="1057" alt="image" src="https://media.github.ibm.com/user/20538/files/9d12362e-89be-11e8-882f-ff3eff088786">

5. It is important to note that the way pods are created differs from the way pods are created as part of deployments. This is specifically because of how the **ControllerManager** verifies PSP's provided the serviceaccount specified in the deployment. Even with the same PSP and clusterrolebindings settings, we can still create a normal privileged pod by executing the following command:

```
kubectl create -f- <<EOF    
apiVersion: v1
kind: Pod
metadata:
  name:      pause
spec:
  containers:
    - name:  pause
      image: k8s.gcr.io/pause
EOF
```

Output:

<img width="449" alt="image" src="https://media.github.ibm.com/user/20538/files/3bbc8fea-89bf-11e8-8752-f07258875551">

6. In order to prevent privileged pod creation in this fashion, you would have to delete the privileged PSP by executing the following command:

**kubectl get psp ibm-privileged-psp -o yaml > psp.yaml**

Output:

<img width="652" alt="image" src="https://media.github.ibm.com/user/20538/files/9130cf4a-89bf-11e8-8cdd-355f708ed9df">

**kubectl delete psp ibm-privileged-psp**

Output:

<img width="549" alt="image" src="https://media.github.ibm.com/user/20538/files/c6a478f2-89bf-11e8-9963-09d5546e34cc">

7. Now run the following command again:

```
kubectl create -f- <<EOF
apiVersion: v1
kind: Pod
metadata:
  name:      pause
spec:
  containers:
    - name:  pause
      image: k8s.gcr.io/pause
EOF
```
8. Run **kubectl get psp** to view the results

Output:

<img width="1246" alt="image" src="https://media.github.ibm.com/user/20538/files/2d06ca82-89c0-11e8-85d0-ce2c3b654ed7">

9. Execute the command: **kubectl get po,deploy**

Output:

<img width="469" alt="image" src="https://media.github.ibm.com/user/20538/files/534669d2-89c0-11e8-93b1-966eb8ff3434">

All the above was done with the 'admin' kubeconfig you get from `bx cs cluster-config`

### Cleanup

1. Run **kubectl delete deployment --all** to delete all deployments.
2. Run **kubectl delete pod pause** to delete pod
2. Restore your backup: **kubectl apply --force=true -f privileged-psp-user.yaml**

## Helpful Commands:

### Getting a list of Pod Security Policies

To get a list of existing policies, use ```kubectl get```:

Output:

<img width="880" alt="image" src="https://media.github.ibm.com/user/20538/files/fc2c8070-8ec7-11e8-8017-421363a650ce">

### Editing a Pod Security Policy

To modify a policy interactively, use ```kubectl edit```:

```$ kubectl edit <PSP_NAME>```

This command will open a default text editor where you will be able to modify the target policy.

### Deleting a Pod Security Policy

Once you don't need a policy anymore, simply delete it with ```kubectl```:

```$ kubectl delete <PSP_NAME>```

# Additional Information Regarding Pod Security Policy

More information on Pod Security Policy can be found [here](https://console.bluemix.net/docs/containers/cs_psp.html#customize_psp) and on Kubernetes website [here](https://kubernetes.io/docs/concepts/policy/pod-security-policy/).
