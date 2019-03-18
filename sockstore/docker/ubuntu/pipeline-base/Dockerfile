##########################################################################################
# Licensed Materials - Property of IBM
# (c) Copyright IBM Corporation 2014. All Rights Reserved.
#
# Note to U.S. Government Users Restricted Rights:
# Use, duplication or disclosure restricted by GSA ADP Schedule
# Contract with IBM Corp.
##########################################################################################
FROM ubuntu:16.04
MAINTAINER Ryan Smith (rws@us.ibm.com)

RUN apt-get update && \
    apt-get clean && \
    apt-get install -q -y sudo zip unzip openssh-server git curl libc6 libcurl3 zlib1g bzip2 build-essential fontconfig libfreetype6 python-software-properties software-properties-common apt-transport-https python-pip libxml2 libsasl2-dev locales && \
    curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash && \
    apt-get install git-lfs && \
    git lfs install && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists

ADD build-scripts/update-logger.sh /tmp/
RUN bash -x /tmp/update-logger.sh && \
    rm -f /tmp/update-logger.sh

RUN locale-gen en_US.UTF-8 && \
    echo LANG=en_US.UTF-8 >> /etc/environment

RUN echo '*    soft nofile 1048576\n\
    *    hard nofile 1048576\n\
    root soft nofile 1048576\n\
    root hard nofile 1048576\n'\
    >> /etc/security/limits.conf

RUN groupadd -r pipeline && \
    useradd -m -s /bin/bash -g pipeline pipeline && \
    sed -ri 's/^session\s+required\s+pam_loginuid.so$/session optional pam_loginuid.so/' /etc/pam.d/sshd

ADD id_rsa_pipeline.pub /home/pipeline/.ssh/authorized_keys
ADD id_rsa_pipeline_go.pub /home/pipeline/.ssh/id_rsa_pipeline_go.pub

ENV BX_VERSION='0.6.6'
RUN wget --quiet -O /tmp/Bluemix_CLI.tar.gz  http://public.dhe.ibm.com/cloud/bluemix/cli/bluemix-cli/${BX_VERSION}/IBM_Cloud_CLI_${BX_VERSION}_amd64.tar.gz && \
    tar -xzvf /tmp/Bluemix_CLI.tar.gz -C /tmp && \
    export PATH=/opt/IBM/cf/bin:$PATH && \
    /tmp/Bluemix_CLI/install_bluemix_cli && \
    rm -rf /tmp/Bluemix_CLI* && \
    bx config --check-version false

USER pipeline
RUN bx config --check-version false && \
    bx plugin install container-service -r Bluemix && \
    bx plugin install container-registry -r Bluemix && \
    bx plugin install cloud-functions -r Bluemix && \
    bx --version && \
    bx plugin list
USER root

RUN wget --quiet --output-document=/usr/local/bin/kubectl  https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x /usr/local/bin/kubectl

RUN /usr/local/bin/kubectl version || true

RUN mkdir -p /tmp/helm_install && \
    curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh && \
    chmod 700 get_helm.sh && \
    ./get_helm.sh --version v2.8.1 && \
    cd && \
    rm -rf /tmp/helm*

ENV JQ_VERSION='1.5'

RUN wget --no-check-certificate https://raw.githubusercontent.com/stedolan/jq/master/sig/jq-release.key -O /tmp/jq-release.key && \
    wget --no-check-certificate https://raw.githubusercontent.com/stedolan/jq/master/sig/v${JQ_VERSION}/jq-linux64.asc -O /tmp/jq-linux64.asc && \
    wget --no-check-certificate https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 -O /tmp/jq-linux64 && \
    gpg --import /tmp/jq-release.key && \
    gpg --verify /tmp/jq-linux64.asc /tmp/jq-linux64 && \
    cp /tmp/jq-linux64 /usr/bin/jq && \
    chmod +x /usr/bin/jq && \
    rm -f /tmp/jq-release.key && \
    rm -f /tmp/jq-linux64.asc && \
    rm -f /tmp/jq-linux64

RUN cat /home/pipeline/.ssh/id_rsa_pipeline_go.pub >> /home/pipeline/.ssh/authorized_keys && \
    rm /home/pipeline/.ssh/id_rsa_pipeline_go.pub

RUN ln -s /home/pipeline /home/jenkins

RUN mv /home/pipeline/.bashrc /home/pipeline/.bashrc.orig
RUN echo source /home/pipeline/.bashrc.orig > /home/pipeline/.bashrc && \
    echo export TMPDIR=/tmp >> /home/pipeline/.bashrc && \
    echo export PATH=\$JAVA_HOME/bin:\$ANT_HOME/bin:\$MAVEN_HOME/bin:\$GRADLE_HOME/bin:/home/pipeline/.npm-global/bin:\$NODE_HOME/bin:/opt/IBM/pipeline/bin:\$PATH >> /home/pipeline/.bashrc && \
    echo 'pipeline ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/pipeline && \
    chmod 0440 /etc/sudoers.d/pipeline

RUN chown -R pipeline:pipeline /home/pipeline && \
    su - pipeline -c 'git config --global http.sslverify false' && \
    su - pipeline -c 'git config --global url."https://".insteadOf git://' && \
    su - pipeline -c 'git config --global http.postBuffer 1048576000'

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
