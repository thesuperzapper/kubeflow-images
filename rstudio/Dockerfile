ARG BASE_IMAGE_REPO=rocker/rstudio
ARG BASE_IMAGE_VERSION=3.6.3
FROM ${BASE_IMAGE_REPO}:${BASE_IMAGE_VERSION}

# Kubeflow Injects
ENV NB_PREFIX /

# Rocker Settings - https://github.com/rocker-org/rocker-versioned/blob/master/rstudio/userconf.sh
ENV USER jovyan
ENV USERID 1000
ENV GROUPID 1000
ENV ROOT TRUE

# Install -- Linux Dependencies
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -yq update \
 && apt-get -yq install --no-install-recommends \
    bash \
    bzip2 \
    ca-certificates \
    curl \
    git \
    gnupg \
    lsb-release \
    sudo \
    unzip \
    vim \
    wget \
    zip \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

## Install -- AWS CLI v2
#RUN curl -sL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip" \
# && unzip -q /tmp/awscliv2.zip \
# && rm -rf /tmp/awscliv2.zip \
# && ./aws/install -i /usr/local/aws-cli -b /usr/local/bin \
# && rm -rf ./aws
#
## Install -- Azure CLI
#RUN export AZ_REPO="$(lsb_release -c -s)" \
# && echo "deb https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" > /etc/apt/sources.list.d/azure-cli.list \
# && curl -sL https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
# && apt-get -yq update \
# && apt-get -yq install --no-install-recommends \
#    azure-cli \
# && apt-get clean \
# && rm -rf /var/lib/apt/lists/*

# Install -- Google Cloud SDK & Kubectl
RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" \
 && echo "deb https://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" > /etc/apt/sources.list.d/google-cloud-sdk.list \
 && curl -sL https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
 && apt-get -yq update \
 && apt-get -yq install --no-install-recommends \
    google-cloud-sdk \
    kubectl \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Apache2 - Install
RUN apt-get -y update \
 && apt-get -y install \
    apache2 \
 && rm -rf /var/cache/apt/* \
 && service apache2 stop

# Apache2 - Setup
COPY services.d/apache2/* /etc/services.d/apache2/
COPY rstudio-proxy.conf /etc/apache2/sites-available/
RUN sudo a2enmod proxy \
 && sudo a2enmod proxy_http \
 && sudo a2enmod rewrite \
 && sudo a2ensite rstudio-proxy \
 && echo "Listen 8888" > /etc/apache2/ports.conf

# R Settings
RUN echo 'auth-none=1' >> /etc/rstudio/rserver.conf \
 && echo 'www-port=8787' >> /etc/rstudio/rserver.conf \
 && echo 'www-address=127.0.0.1' >> /etc/rstudio/rserver.conf \
 && echo 'www-frame-origin=any' >> /etc/rstudio/rserver.conf

EXPOSE 8888
CMD ["/init"]