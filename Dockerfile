FROM quay.io/redsift/baseos
LABEL author.name="Karl Norling" \
  author.email="karl@redsift.io" \
  version="1.1.104" \
  organization="Red Sift"

RUN export DEBIAN_FRONTEND=noninteractive && \
  apt-get update && \
  apt-get install -y curl \
  libpython-stdlib libpython2.7-minimal libpython2.7-stdlib mime-support python python-minimal python2.7 python2.7-minimal python-pip git && \
  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG nv="12.18.4"

ENV NVM_VERSION 0.35.3
ENV NVM_DIR ${HOME}/.nvm
ENV NODE_VERSION "${nv}"
ENV NPM_VERSION 6.14.6

# node has dropped http header size from 80K to 8K
ENV NODE_OPTIONS='--max-http-header-size=81000 --trace-warnings'

# Install nvm with node and npm
RUN curl https://raw.githubusercontent.com/creationix/nvm/v$NVM_VERSION/install.sh | bash \
  && . $NVM_DIR/nvm.sh \
  && nvm install $NODE_VERSION \
  && nvm alias default $NODE_VERSION \
  && nvm use default \
  && npm i -g npm@$NPM_VERSION \
  && npm_config_user=root npm install -g bunyan --quiet

ENV NODE_PATH $NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# Version dump
RUN echo "NodeJS" `node -v` && \
  echo "NPM" `npm -v`

# Define working directory.
WORKDIR /
