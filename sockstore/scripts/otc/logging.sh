#!/bin/bash
set -x

# Necessary commands for setting up mt-logstash-forwarder
apt-get install -y wget
apt-get install -y tzdata
ln -fs /usr/share/zoneinfo/US/Central /etc/localtime && dpkg-reconfigure -f noninteractive tzdata
apt-get install -y ntp
apt-get install -y ntpdate
service ntp start
wget -O - https://downloads.opvis.bluemix.net/client/IBM_Logmet_repo_install.sh | bash
apt-get install mt-logstash-forwarder

mkdir /home/pipeline/logs
touch /home/pipeline/logs/logging-otc.log

/opt/mt-logstash-forwarder/init/deb-init.d/mt-logstash-forwarder.init start

echo 'LSF_INSTANCE_ID="swarm-otc-logs"' > /etc/mt-logstash-forwarder/mt-lsf-config.sh
echo 'LSF_TARGET="ingest.logging.ng.bluemix.net:9091"' >> /etc/mt-logstash-forwarder/mt-lsf-config.sh
echo 'LSF_TENANT_ID="a:ad5d072102214f4395eab22f03bbb2f9"' >> /etc/mt-logstash-forwarder/mt-lsf-config.sh
echo 'LSF_PASSWORD="5fHX1j4UDBMV"' >> /etc/mt-logstash-forwarder/mt-lsf-config.sh
echo 'LSF_GROUP_ID="swarm-otc-logging"' >> /etc/mt-logstash-forwarder/mt-lsf-config.sh

echo '# The list of files configurations
{
    "files": [
        {
        "paths": ["/home/pipeline/logs/logging-otc.log"],
        "fields": { "type": "swarm-otc" },
        "is_json": false
    }
    ]
}' > /etc/mt-logstash-forwarder/conf.d/sockstore.conf

/opt/mt-logstash-forwarder/init/deb-init.d/mt-logstash-forwarder.init force-reload

echo "${BUILD_ID}: mt-logstash-forwarder started" | tee -a /home/pipeline/logs/logging-otc.log
echo "${BUILD_ID}: mt-logstash-forwarder sleeping" | tee -a /home/pipeline/logs/logging-otc.log
echo -e "\n" >> /home/pipeline/logs/logging-otc.log
cat /home/pipeline/logs/logging-otc.log

sleep 1m
