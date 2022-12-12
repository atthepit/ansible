FROM ubuntu:focal AS base
WORKDIR /usr/local/bin
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common build-essential && \
    apt-add-repository -y ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y curl git ansible && \
    apt-get clean autoclean && \
    apt-get autoremove --yes

FROM base AS extra
ARG TAGS
RUN addgroup --gid 1000 pit
RUN adduser --gecos pit --uid 1000 --gid 1000 --disabled-password pit
USER pit
WORKDIR /home/pit/ansible

FROM extra
COPY --chown=pit:pit . .
CMD ["sh", "-c", "ansible-playbook $TAGS local.yml"]

