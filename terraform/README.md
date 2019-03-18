# How to execute this Terraform Plan

## Overview

This documentation will walk through how to use this Terraform Plan.  The initial setup is defined and the commands for applying this plan will all be explained below.

The sample application that is being used to demonstrate that it is possible to deploy an application using this Terraform plan is called Sockstore.  

## Terraform Plan - Automated Provisioning & App Deployment

This plan will provision public and private VLANs, then provision an IBM IKS Cluster using those VLANs.  The terraform plan also configures a cname on an existing domain and an instance of AppID service.

### Prerequisites

+ Install [Terraform](https://www.terraform.io/intro/getting-started/install.html)
+ Install [Terraform-Provider-IBM](https://github.com/IBM-Cloud/terraform-provider-ibm/releases)
+ Make sure you have these four environment variables set:
  + BM_API_KEY
  + BM_REGION
  + SL_USERNAME
  + SL_API_KEY
+ Edit tf-files/variables.tf with your own credentials and naming preferences

  *If you'd like to change the variable, dns_domain, you will need to create that domain manually and then reset the variable so the terraform plan uses it.  This plan does not create a domain, it only creates a cname on that domain.*

### Step 1:
This first step is to view what your terraform plan will be provisioning, before actually provisioning anything.  

Navigate to the **/tf-files directory** and run the following command:
```
terraform plan
```
*If the command below does not specify which .tf file to perform the command on, then it will perform it on each .tf file that is within that directory.*

In order to validate that the command above worked, look at the terminal print out.  You should see something like this:

*Insert picture here*

### Step 2:
Once you verify that the plan looks correct, next you can run the command to actually provision the plan:

```
terraform apply
```
*If the command below does not specify which .tf file to perform the command on, then it will perform it on each .tf file that is within that directory.*

Validate that the apply worked using:
```
terraform show
```

## Clean Up
Below is the command you can use to *undo* the provisioning that you just did using Step 1 & Step 2.  

```
terraform destroy
```
*If the command below does not specify which .tf file to perform the command on, then it will perform it on each .tf file that is within that directory.*  

## Wrap Up
This documentation has walked through the process of setting up your environment for using Terraform, how to execute a terraform plan, and also how to clean up the resources that were provisioned.  

## References
[Terraform](https://www.terraform.io/intro/getting-started/install.html)

[Terraform Provider IBM Downloads](https://github.com/IBM-Cloud/terraform-provider-ibm/releases)

[Terraform Provider IBM Docs](https://ibm-cloud.github.io/tf-ibm-docs/)
