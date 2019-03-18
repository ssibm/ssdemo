
# proton

HPC Application as a Service, code-named _proton_, is an IBM Cloud service under development in partnership with Rescale.  

**Platform**: IBM Cloud  
**Resource Provider (RP)**: Rescale  
**User, End-User**: IBM Cloud user logged in using IBMid  

* [Helpful Links](#helpful-links)
* [Overview](#overview)
* [Design](#design)
  + [Workflow](#workflow)
  + [Service Broker](#service-broker)
    + [Commands](#commands)
    + [Security](#security)
    + [Resiliency](#resiliency)
  + [Platform integration](#platform-integration)
    + [Logging](#logging)
    + [Billing](#billing)
    + [Activity Tracker](#activity-tracker)
* [CI/CD](#ci-cd)
  + [Build](#build)
  + [Deploy](#deploy)
  + [Validate](#validate)
* [Onboard Service](#onboard-service)
  + [Concept Car](#concept-car)

## Helpful Links
* [Solution Documents](https://ibm.box.com/s/8j61exfyc9he6lkop73t0zy32etm3zcv)
* [#ibm-rescale-hpc](https://ibm-cloudplatform.slack.com/messages/G8XM3BCMD)

## Overview
Offered in IBM Cloud **Catalog** under **Platform** > **Application Services** category, each IBM Cloud Account can create upto a maximum of one instance of this service per region. (TBD _make sure per region statement is correct_)

Logged in IBM Cloud User can request service creation and deletion. After service is created, it is available in its own web page with a launch button that opens the Resource Provider's dashboard in a secure web browser session. From this session the user can run HPC jobs, create HPC clusters, upload and download data files.

Services consumed from the secure dashboard are metered by the RP and billed to the user's account by IBM Cloud.

## Design
This service uses a service broker that processes incoming requests from IBM Cloud platform by forwarding them to the Resource Provider and sending back the response to the Platform.

Resource Controller is the provisioning layer in IBM Cloud platform that sends the requests to the Service Broker. The broker for this service is onboarded to IBM Cloud platform as a provision-through RC-enabled service broker.

### Workflow
![](img/workflow.png?raw=true)

IBM Cloud user logs into the Dashboard and triggers an action to either create, delete, or use the HPC service.

Depending on the user action, IBM Cloud Resource Controller (RC) sends Catalog and Provisioning requests to the Service Broker (SB). The broker uses data from the incoming request payload and sends a request to the RP. Resource Provider processes the request and sends back the response. SB sends that response over to RC to complete the cycle of processing the user request.

SB sends logs including audit, output, and error information to Logging and Activity Tracker service endpoints in the Platform. Billing data, including usage and metering is pushed from the RP to the Billing service endpoint in the Platform.

### Service Broker
Service Broker provides RESTful service endpoints to the Resource Controller, and functions as a client to the Resource Provider. It is deployed as a set of kubernetes resources to a IBM Cloud Containers Cluster.

#### Commands
Following REST commands are implemented in this service broker.

##### Get Catalog Information
TBD

##### Provision Service
![](img/create-service.png?raw=true)
TBD

##### Delete Service
TBD

#### Security
TBD

#### Resiliency
TBD

### Platform Integration
TBD

#### Activity Tracker
TBD

#### Logging
TBD

#### Billing
TBD

## CI/CD

### Build
TBD

### Deploy
TBD

### Validate
TBD

## Onboard Service
TBD
### Concept Car
TBD