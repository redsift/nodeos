FROM quay.io/redsift/baseos:24.04
LABEL author.name="Randal Pinto" \
  author.email="randal@redsift.io" \
  version="1.2.0" \
  organization="Red Sift"

RUN export DEBIAN_FRONTEND=noninteractive && \
  apt-get update && \
  apt-get install -y curl git ca-certificates \
  python3 python3-pip python3-setuptools python-is-python3 build-essential && \
  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG nv="22.11.0"

ENV NVM_VERSION 0.40.1
ENV NVM_DIR ${HOME}/.nvm
ENV NODE_VERSION "${nv}"

# node has dropped http header size from 80K to 8K
ENV NODE_OPTIONS='--max-http-header-size=81000 --trace-warnings'

# Install nvm with node and npm
RUN curl https://raw.githubusercontent.com/creationix/nvm/v$NVM_VERSION/install.sh | bash \
  && . $NVM_DIR/nvm.sh \
  && nvm install $NODE_VERSION \
  && nvm alias default $NODE_VERSION \
  && nvm use default \
  && npm_config_user=root npm install -g bunyan --quiet

ENV NODE_PATH $NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# Version dump
RUN echo "NodeJS" `node -v` && \
  echo "NPM" `npm -v`

# Define working directory.
WORKDIR /
