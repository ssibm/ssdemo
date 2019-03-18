# Sending logs from a Node application running in Kubernetes to Log Analysis

### Objective: To ingest logs created from a Node application running in an IBM Cloud cluster into Log Analysis. Deploy the Node application into the cluster using Helm.

### Prerequisites
- IBM Cloud cluster
- [IBM Cloud CLI](https://console.bluemix.net/docs/cli/index.html#overview)
- A Node application with logging to an output file (such as Winston)
- A running instance of Log Analysis

## Instructions for sending Logs to Log Analysis

1. Log in to IBM Cloud through the CLI.
  ```
  bx login
  ```

2. If you don't have the IBM Cloud Container Services plugin installed, you can do so by running the command:
  ```
  bx plugin install container-service -r Bluemix
  ```
  You can then access the plugin by using:
  ```
  bx cs
  ```

3. Create a logging configuration for your Node application.
  ```
  bx cs logging-config-create <cluster> --namespace <namespace> --logsource application --type ibm --app-paths '<path to log>'
  ```
  The application path should be pointing to the log file where you are outputting from your Node application. NOTE: If you are sending logs to both Activity Tracker and Log Analysis, they must be separate log files and the logs being sent to Log Analysis should not be in the same directory as the Activity Tracker logs.

4. Verify that your configuration has been created.
  ```
   bx cs logging-config-get <cluster name or ID>
   ```

5. Apply your changes.
  ```
   bx cs logging-config-refresh <cluster name>
   ```

6. Start outputting logs from your Node application to the log file that you specified previously. It can be as simple as a single JSON object.
  ```
  {"message":"Testing logs"}
  ```

7. Launch Log Analysis and you should begin seeing your logs being successfully retrieved!

### Helpful Links
- https://console.bluemix.net/docs/containers/cs_health.html#logging
- https://pages.github.ibm.com/alchemy-logmet/
