FROM quay.io/redsift/baseos
MAINTAINER Rahul Powar email: rahul@redsift.io version: 1.0.102

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y curl \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
	
# Install NodeJS
RUN curl -sL https://deb.nodesource.com/setup_0.12 | bash - && \
	export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
	apt-get install -y nodejs && \
	apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
	npm install -g bunyan --quiet

# Version dump
RUN \
	echo "NodeJS" `nodejs -v` && \
	echo "NPM" `npm -v`

# Define working directory.
WORKDIR /
