The **vlan.tf** file contains Cloud resource definitions for VLANs. You can create and configure IBM Cloud VLAN resources using 
the **vlan.tf** file and terraform commands. The file uses variable to define a target data center and account GUID for IBM Container 
Service. You can retrieve available data center names by running the ```bx cs locations``` command in the IBM Cloud CLI.

<img width="1198" alt="image" src="https://media.github.ibm.com/user/20538/files/c01d864c-b68b-11e8-8370-c57f4b7b97f5">

You can also retrieve the account GUID by running the ```bx iam accounts``` command. 

<img width="887" alt="image" src="https://media.github.ibm.com/user/20538/files/d4d4ff7a-b68b-11e8-9bd4-c6921fd101f3">

Open the file, **vlan.tf** and update the value of dc and account_guid. For example, if the target datacenter is *dal13* and 
the account GUID is *1234567abcd1234*, you can update the file as follows:

```hcl
variable dc1 {
    default = "dal13"
}

variable account_guid {
   default = "1234567abcd1234"
}
```
