FROM gocd/gocd-agent:16.7.0

WORKDIR /iac

# installpip and ansible deps (devel libraries)
RUN apt-get update && \
    apt-get -y install \
    python-pip \
    python-yaml \
    python-jinja2 \
    python-httplib2 \
    python-paramiko \
    python-pkg-resources \
    python-keyczar \
    python-setuptools \
    build-essential

# install the heart of this container
RUN pip install awscli boto ansible

# latest version of ansible ec2 dynamic inventory
RUN curl -s \
    -O https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/ec2.py \
    -O https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/ec2.ini

ENTRYPOINT [ "ansible-playbook" ]
CMD ["-i ec2.py"]
