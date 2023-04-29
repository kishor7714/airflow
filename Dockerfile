FROM ubuntu:latest
ENV PORT=8000
LABEL maintainer="Chris <c@crccheck.com>"

RUN apt update
RUN apt install -y vim git
RUN apt install -y default-jdk