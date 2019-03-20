Follow the instructions here to use this Terraform plan and deploy IBM Cloud resources.  

### Prerequisites

+ Install [Terraform](https://www.terraform.io/intro/getting-started/install.html)
+ Install [Terraform-Provider-IBM](https://github.com/IBM-Cloud/terraform-provider-ibm/releases)
+ Clone repo `git clone https://github.com/ssibm/ssdemo.git && cd terraform`  
+ Edit `variables.tf` or add `terraform.tfvars` and set your IBM Cloud API keys and IBM Cloud (Softlayer) username. Also set other values including `region`, `zones`, `cf_org`, `cf_space`

### Apply terraform plan

```
$ terraform init
$ terraform plan
```

Verify that the plan looks correct. Next run the command to apply the plan to provision resources.  

```
$ terraform apply
```

### Clean Up

```
$ terraform destroy
```

## References
[Terraform](https://www.terraform.io/intro/getting-started/install.html)

[Terraform Provider IBM Downloads](https://github.com/IBM-Cloud/terraform-provider-ibm/releases)

[Terraform Provider IBM Docs](https://ibm-cloud.github.io/tf-ibm-docs/)
