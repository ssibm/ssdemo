FROM ubuntu:xenial

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get update -y && apt-get install -y dialog apt-utils
RUN apt-get upgrade -y

# Installing IBM Cloud CLI
RUN apt-get install -y curl
RUN curl -fsSL https://clis.ng.bluemix.net/install/linux | sh

# Installing Kubernetes command-line tool (kubectl)
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl

# Installing helm CLI
RUN curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh
RUN chmod 700 get_helm.sh
RUN ./get_helm.sh

WORKDIR /home

VOLUME /run /tmp

EXPOSE 22
CMD /usr/sbin/init
CMD ["/usr/sbin/sshd", "-D"]
