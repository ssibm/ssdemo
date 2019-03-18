# Overview

Ingress is a Kubernetes service that balances network traffic workloads in your cluster by forwarding public or private requests to your apps. You can use Ingress to expose multiple app services to the public or to a private network by using a unique public or private route.

The following steps provided below are instructions on how to terminate a certificate using ingress. Additional information similar to these steps can be found at [**Exposing apps with Ingress**](https://console.bluemix.net/docs/containers/cs_ingress.html#ingress) website.

## Instructions and Prerequisites:

1. A cluster with ingress installed is required
2. The following `.yaml` files listed below are required. These `.yaml` files can be located by clicking on each `.yaml` file below or access all files [here](https://github.ibm.com/customer-success/swarm/tree/master/tls-termination/yamlfiles)

- [**my-nginx-deployment.yaml**](https://github.ibm.com/customer-success/swarm/blob/master/tls-termination/yamlfiles/my-nginx-deployment.yaml)
- [**index.php**](https://github.ibm.com/customer-success/swarm/blob/master/tls-termination/yamlfiles/index.php)
- [**my-nginx-service.yaml**](https://github.ibm.com/customer-success/swarm/blob/master/tls-termination/yamlfiles/my-nginx-service.yaml)
- [**my-nginx-ingress-custom.yaml**](https://github.ibm.com/customer-success/swarm/blob/master/tls-termination/yamlfiles/my-nginx-ingress-custom.yaml) Be sure to replace `<Ingress Subdomain>` for **hosts:**, and `<Ingress Secret name>` for **Ingress Secret:** with your cluster's information.
- [**my-nginx-ingress.yaml**](https://github.ibm.com/customer-success/swarm/blob/master/tls-termination/yamlfiles/my-nginx-ingress.yaml) Be sure to replace `<Ingress Subdomain>` for **hosts:**, and `<Ingress Secret name>` for **Ingress Secret:** with your cluster's information.

### Configuration and Implementation Steps:

1. Get the details for your cluster by executing `ibmcloud ks cluster-get <cluster_name_or_ID>`. Replace **<cluster_name_or_ID>** with the name of the cluster where the apps that you want to expose are deployed.

`$ ibmcloud ks cluster-get sg-cluster3n`

<img width="1325" alt="image" src="https://media.github.ibm.com/user/20538/files/e2949178-95e0-11e8-96b2-3d83d9afcfae">

1. Define and create `my-nginx-deployment.yaml`

`$ kubectl apply -f my-nginx-deployment.yaml`

<img width="572" alt="image" src="https://media.github.ibm.com/user/20538/files/3258da28-95de-11e8-9bbd-2dd0ed732b1d">

2. Apply `index.php`

`$ kubectl get pods | grep my-nginx | awk '{ printf ("kubectl cp index.php %s:/app/index.php\n", $1)}'`

<img width="976" alt="image" src="https://media.github.ibm.com/user/20538/files/4a3152e2-95de-11e8-8b7d-af8dde0a9db1">

3. Copy and paste each `kubectl cp ...` results in the terminal and press **enter** to execute

`$ kubectl cp index.php my-nginx-5b88bdd4d9-4dpbv:/app/index.php`

`$ kubectl cp index.php my-nginx-5b88bdd4d9-78p4b:/app/index.php`

`$ kubectl cp index.php my-nginx-5b88bdd4d9-pdk8z:/app/index.php`

<img width="974" alt="image" src="https://media.github.ibm.com/user/20538/files/cd5392ac-95de-11e8-9936-40272308c73e">

4. Define and create `my-nginx-service.yaml`

`$ kubectl apply -f my-nginx-service.yaml`

<img width="544" alt="image" src="https://media.github.ibm.com/user/20538/files/245e0426-95dd-11e8-8ce4-fa99ca3aa580">

5. Create and define `my-nginx-ingress-custom.yaml`

`$ kubectl apply -f my-nginx-ingress-custom.yaml`

<img width="603" alt="image" src="https://media.github.ibm.com/user/20538/files/2fc09554-969b-11e8-8eb0-7ed57694b06a">

6. From the details of your cluster in step 1 copy the `Ingress Subdomain:` address. Paste the address in a web browser address bar starting with `https://` and ending with `/index.php`.

***Example***

`https://sg-cluster3n.us-south.containers.appdomain.cloud/index.php`

***Output:***

<img width="1343" alt="image" src="https://media.github.ibm.com/user/20538/files/f2ed3708-969b-11e8-8fed-c3fcf09531ed">

7. By clicking on the security lock <img width="57" alt="image" src="https://media.github.ibm.com/user/20538/files/3926c6f8-969c-11e8-9627-1aa07cc43443"> in the address bar or clicking on the `view site information` you will be able to see the certificate information and the Transport Layer Security (TLS) details.

***Example***

<img width="483" alt="image" src="https://media.github.ibm.com/user/20538/files/b355b646-969c-11e8-8978-49eea338e848">

### Cleanup

In your terminal execute the following commands to remove all work performed above.

1. `$ kubectl delete -f my-nginx-deployment.yaml`

2. `$ kubectl delete -f my-nginx-service.yaml`

3. `$ kubectl delete -f my-nginx-ingress-custom.yaml`

Similar process can be performed to create a self-signed certificate by following the steps below:

1. Updated the `/etc/hosts` file and add your FQDN and the IP address in the file. The IP address can be identified by pinging your `<Ingress Subdomain>` address.

<img width="421" alt="image" src="https://media.github.ibm.com/user/20538/files/4c4f5a4c-96a1-11e8-9ac8-14f751bb6795">

2. Define and create `my-nginx-deployment.yaml`

`$ kubectl apply -f my-nginx-deployment.yaml`

<img width="572" alt="image" src="https://media.github.ibm.com/user/20538/files/3258da28-95de-11e8-9bbd-2dd0ed732b1d">

3. Apply `index.php`

`$ kubectl get pods | grep my-nginx | awk '{ printf ("kubectl cp index.php %s:/app/index.php\n", $1)}'`

<img width="976" alt="image" src="https://media.github.ibm.com/user/20538/files/4a3152e2-95de-11e8-8b7d-af8dde0a9db1">

4. Copy and paste each `kubectl cp ...` results in the terminal and press **enter** to execute

`$ kubectl cp index.php my-nginx-5b88bdd4d9-4dpbv:/app/index.php`

`$ kubectl cp index.php my-nginx-5b88bdd4d9-78p4b:/app/index.php`

`$ kubectl cp index.php my-nginx-5b88bdd4d9-pdk8z:/app/index.php`

<img width="974" alt="image" src="https://media.github.ibm.com/user/20538/files/cd5392ac-95de-11e8-9936-40272308c73e">

5. Define and create `my-nginx-service.yaml`

`$ kubectl apply -f my-nginx-service.yaml`

<img width="544" alt="image" src="https://media.github.ibm.com/user/20538/files/245e0426-95dd-11e8-8ce4-fa99ca3aa580">

6. Create and define `my-nginx-ingress.yaml`

`$ kubectl apply -f my-nginx-ingress.yaml`

<img width="547" alt="image" src="https://media.github.ibm.com/user/20538/files/b5b0ad90-96a3-11e8-894e-5ee4976e0762">

7. Generated a self-signed certificate and regisered it by executing the following command:

`openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /tmp/tls.key -out /tmp/tls.crt -subj "/CN=www.<YOUR FQDN.com"”`

<img width="1124" alt="image" src="https://media.github.ibm.com/user/20538/files/b2b861f4-96a4-11e8-9dac-8ef7bca692c4">

`kubectl create secret tls <YOUR secretName> --key=/tmp/tls.key --cert=/tmp/tls.crt`

<img width="804" alt="image" src="https://media.github.ibm.com/user/20538/files/104d5e14-96a5-11e8-86d1-ef64188e9ae3">

8. Launch a browser and enter your ***www.FQDN.com*** address.

***Example***

<img width="1342" alt="image" src="https://media.github.ibm.com/user/20538/files/f267a00c-96a5-11e8-9cb1-c12061aa734c">

9. By clicking on the security lock <img width="57" alt="image" src="https://media.github.ibm.com/user/20538/files/3926c6f8-969c-11e8-9627-1aa07cc43443"> in the address bar or clicking on the `view site information` you will be able to see the certificate information and the Transport Layer Security (TLS) details.

***Example***

<img width="1029" alt="image" src="https://media.github.ibm.com/user/20538/files/a64a1e16-96a5-11e8-8821-51e5c0cefc87">

### Cleanup

In your terminal execute the following commands to remove all work performed above.

1. `$ kubectl delete -f my-nginx-deployment.yaml`

2. `$ kubectl delete -f my-nginx-service.yaml`

3. `$ kubectl delete -f my-nginx-ingress.yaml`

4. 

`$ cd /tmp`

`$ ls`

`$ rm tls.crt`

`$ rm tls.key`
