# Sending logs from a Node application running in an IBM Cloud cluster to Activity Tracker

### Objective: To ingest logs created from a Node application running in a Kubernetes cluster into Activity Tracker. Deploy the Node application into the cluster using Helm.

### Prerequisites
- IBM Cloud cluster
- A Node application with logging to an output file (such as Winston)
- A running instance of Activity Tracker
- [Kubernetes command-line tool, `kubectl`, installed](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

## Instructions for sending Logs to Activity Tracker

1. In order to send logs to Activity Tracker, you need to register the service with the Activity Tracker team. You can do so by opening up an issue in their GitHub repo [here](https://github.ibm.com/activity-tracker/customer-issues/issues/new).

2. Create a file named `encodedServices.sh` and copy the following into it, replacing the values with the information you received in the previous step.
  ```sh
  echo '{"services":[{"service_name":"YOUR_SERVICE_NAME","auth_token_value":"YOUR_SERVICE_TOKEN","project_id": "YOUR_SERVICE_SPACE_ID"}]}' | base64
  ```
  Run the script and copy the output to be used in the next step.

3. Create a yaml file for a secret that we'll be adding to your cluster. Put the following text into it, replacing the `ACTIVITY_TRACKER_URL` with the URL you registered your service with earlier (it'll look something like activity-tracker.ng.bluemix.net) and `ENCODED_SERVICES` with the output from the previous step.
  ```yaml
  apiVersion: v1
  data:
    ACTIVITY_TRACKER_URL: ENCODED_SERVICES
  kind: Secret
  metadata:
    name: activity-tracker-secrets
    namespace: kube-system
  type: Opaque
  ```
  Run the command `kubectl create -f <SECRET_FILE>.yaml`. If you receive an error saying that the secret already exists, you can delete it by running `kubectl -n kube-system delete secret activity-tracker-secrets`.

4. Create another yaml file for a configmap that we'll be adding to your cluster. Put the following text in it, replacing the `ACTIVITY_TRACKER_URL` and `ACTIVITY_TRACKER_REGION`.
  ```yaml
  apiVersion: v1
  data:
    logging-activity-tracker.conf: |
      <source>
        type tail
        path /var/log/at/**/*.log
        exclude_path /var/log/at/**/*.gz
        pos_file /mnt/ibm-kube-fluentd-persist/fluentd-at.pos
        time_format %Y-%m-%dT%H:%M:%S
        tag kubernetes.at.*
        format json
        read_from_head true
        read_lines_limit 100
        rotate_wait 43200 # set to 12 hours in case AT gets behind in reading events
      </source>
      <match kubernetes.at.**>
        type ibmactivitytracker
        targetHost ACTIVITY_TRACKER_URL
        service_region ACTIVITY_TRACKER_REGION
        ibm_plugin_log_level warn
        flush_interval 10s
        buffer_queue_full_action exception
        buffer_queue_limit 10
        buffer_chunk_limit 2m
        buffer_type file
        buffer_path /mnt/ibm-kube-fluentd-persist/fluentd-at-buffer.buf
        secrets_path /mnt/activity-tracker/secrets
        retry_wait 1s
        max_retry_wait 10s
        disable_retry_limit true
      </match>
  kind: ConfigMap
  metadata:
    name: at-fluentd-config
    namespace: kube-system
  ```
  Run the command `kubectl create -f <CONFIG_FILE>.yaml`. This will create a configmap that tells Activity Tracker to look at any logs within `/var/log/at`.

5. Restart the fluentd pods in your cluster in order to trigger the new configuration. Create a shell script and execute the following code inside it.
  ```sh
  kubectl -n kube-system delete pods -l app=ibm-kube-fluentd
  sleep 30
  kubectl -n kube-system get pods -l app=ibm-kube-fluentd
  ```

6. Deploy your Node application using Helm. You can look at the `charts` folder to see the Helm deployment for our example application. Make sure that you create a volume and volumeMount it to your deployment at `/var/log/at` (see `charts/broker/templates/depl.yaml)` if you are unsure how).

7. Output logs from your Node application to a `.log` file located in `/var/log/at`. Log files can ONLY be parsed by Activity Tracker if they are in standard CADF format. You can take a look at the code within the `broker` directory to see how you can do this using Winston.

8. Launch Activity Tracker from your IBM Cloud dashboard and you should start seeing your events be ingested soon after you begin logging them in CADF format to a .log file!

### Helpful Links
- https://pages.github.ibm.com/activity-tracker/getting-start/kube/
- https://github.ibm.com/activity-tracker/helloATv2
