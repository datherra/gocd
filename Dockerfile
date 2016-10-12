FROM python:2.7.12

WORKDIR /iac

# useful cache for quick tries when in dev-mode
RUN apt-get update

# install the heart of this container
RUN pip install ansible awscli boto credstash

WORKDIR /iac
COPY ./ /iac/

ENTRYPOINT ["scripts/entrypoint.sh"]
