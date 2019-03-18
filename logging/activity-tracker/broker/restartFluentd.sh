kubectl -n kube-system get pods -l app=ibm-kube-fluentd | grep -v NAME > fluent_pods.txt

numPods=$(wc -l fluent_pods.txt | awk '{ print $1 }')

echo "There are $numPods to delete"

while read line; do
  echo "There are $numPods left to delete"
  name=$(echo $line | cut -d ' ' -f1 | xargs)
  kubectl -n kube-system delete pod $name
  numPods=$((numPods-1))
  sleep 3
done <fluent_pods.txt

echo “pods are all updated, waiting for a bit then checking status”
sleep 30
kubectl -n kube-system get pods -l app=ibm-kube-fluentd