ARG BASE_IMAGE_REPO=continuumio/anaconda3
ARG BASE_IMAGE_VERSION=2020.02
FROM ${BASE_IMAGE_REPO}:${BASE_IMAGE_VERSION}

ARG NB_UI_TYPE=lab

ARG INSTALL_SPARK=false
ARG INSTALL_SPARK_VERSION=2.4.6

ENV NB_UI_TYPE=${NB_UI_TYPE}
ENV NB_USER jovyan
ENV NB_UID 1000
ENV NB_PREFIX /

ENV INSTALL_SPARK=${INSTALL_SPARK}

ENV HOME /home/$NB_USER

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
    locales \
    lsb-release \
    software-properties-common \
    sudo \
    unzip \
    vim \
    wget \
    zip \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Install/Update -- Jupyter Notebook/Lab
RUN conda install -y --quiet \
    notebook \
    jupyterlab \
 && conda clean -y -a -f

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

# Install -- tini
RUN curl -sL https://github.com/krallin/tini/releases/download/v0.19.0/tini -o /tmp/tini \
 && echo "93dcc18adc78c65a028a84799ecf8ad40c936fdfc5f2a57b1acda5a8117fa82c /tmp/tini" | sha256sum -c - \
 && mv /tmp/tini /usr/local/bin \
 && chmod +x /usr/local/bin/tini

# Install --Java & SPARK, only if SPARK_INSTALL is true
RUN if [ "$INSTALL_SPARK" = "true" ]; then \
      sudo mkdir -p /usr/share/man/man1 \
      && wget -O- https://apt.corretto.aws/corretto.key | sudo apt-key add - \
      && add-apt-repository 'deb https://apt.corretto.aws stable main' \
      && apt-get -yq update \
      && apt-get -yq install --no-install-recommends \
         java-1.8.0-amazon-corretto-jdk \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/* \
      && conda install -y --quiet -c conda-forge \
         pyspark==${INSTALL_SPARK_VERSION} \
      && conda clean -y -a -f \
    ; fi

# Create NB_USER user with UID=1000 and in the 'users' group
# but allow for non-initial launches of the notebook to have
# $HOME provided by the contents of a PV
RUN useradd -M -s /bin/bash -N -u ${NB_UID} ${NB_USER} \
 && chown -R ${NB_USER}:users /usr/local/bin \
 && mkdir -p $HOME \
 && chown -R ${NB_USER}:users ${HOME}

# Make NB_USER a sudoer
RUN adduser $NB_USER sudo \
 && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# setup conda/jupyter
ENV SHELL /bin/bash
RUN echo "conda activate base" >> /etc/profile \
 && chown -R ${NB_USER}:users /opt/conda/

# set locale
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
 && locale-gen

COPY entrypoint.sh /opt/entrypoint.sh
RUN chmod a+x /opt/entrypoint.sh

EXPOSE 8888
USER jovyan

COPY example_notebooks/ /opt/example_notebooks/
ENTRYPOINT ["/opt/entrypoint.sh"]
CMD ["sh", "-c", "jupyter ${NB_UI_TYPE} --notebook-dir=/home/${NB_USER} --ip=0.0.0.0 --no-browser --allow-root --port=8888 --NotebookApp.token='' --NotebookApp.password='' --NotebookApp.allow_origin='*' --NotebookApp.base_url=${NB_PREFIX}"]
