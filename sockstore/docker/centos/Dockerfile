FROM centos:centos7

RUN yum update -y
RUN yum install -y wget
RUN yum install -y ntp
RUN yum install -y ntpdate

WORKDIR /home

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
