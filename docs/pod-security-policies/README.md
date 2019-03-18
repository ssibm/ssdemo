## Overview

**Pod Security Policies** is explained and a demo instructions is provided in [kubernetespodsecuritypolicies.md](https://github.ibm.com/customer-success/swarm/blob/master/pod-security-policies/kubernetespodsecuritypolicies.md). The instructions on the demo located in [kubernetespodsecuritypolicies.md](https://github.ibm.com/customer-success/swarm/blob/master/pod-security-policies/kubernetespodsecuritypolicies.md) page is to provide a user a high-level overview of how _to prevent everyone except the cluster administrator from creating a privileged container in the default namespace_.

In the example use case it is assumed that a working kubernetes environment is already setup in a cluster before proceeding with the instructions provided in the [kubernetespodsecuritypolicies.md](https://github.ibm.com/customer-success/swarm/blob/master/pod-security-policies/kubernetespodsecuritypolicies.md). 

The *.yaml* files used in this case can be viewed and downloaded [here](https://github.ibm.com/customer-success/swarm/tree/master/pod-security-policies/yamlfiles). 

<img width="94" alt="image" src="https://media.github.ibm.com/user/20538/files/0eec6382-89b5-11e8-9ea7-51737b086961">

It is **`NOT`** recommended to perform these test cases in a production cluster.
