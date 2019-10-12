#################################################
## This Dockerfile installs minimal env for BigDL
##      - JDK8 (oracle)
##      - Spark
##      - BigDL
##      - Conda Python 3.6 environment
##      - Tensorflow and Tensorboard
##  All software installed in : /opt
#################################################

## pick latest or a specific version (to ensure predictability)
FROM jupyter/scipy-notebook:latest

LABEL maintainer="Elephant Scale <info@elephantscale.com>"


## -- env variables to be used in the container -----
ARG INSTALL_DIR=/opt
ENV BIGDL_HOME          ${INSTALL_DIR}/BigDL
ENV SPARK_HOME          ${INSTALL_DIR}/spark
ENV ANALYTICS_ZOO_HOME  ${INSTALL_DIR}/analytics-zoo
ENV JAVA_HOME           ${INSTALL_DIR}/jdk
ENV PATH                ${INSTALL_DIR}/spark/bin:${JAVA_HOME}/bin:$PATH
ENV WORKING_DIR         ${HOME}/work
ENV TENSORBOARD_DIR     ${WORKING_DIR}/tensorboard-logs
## --- end CONFIG


## Do system updates first and then install our custom software (bigdl, spark ..etc)
## This way  we don't bust the cache when we experiment with different versions


## -------- system updates -------

USER root



## apt update
RUN apt-get update -yq && \
    apt-get -yq upgrade
    #apt-get -yq dist-upgrade

## basic utils
RUN apt-get install -yq  --no-install-recommends \
    atop \
    curl \
    git \
    maven \
    less \
    jq \
    nano \
    rsync \
    vim \
    unzip \
    wget \
    zip

## cleanup apt
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*


## --- install/update conda python env ------
# now as a regular user
USER $NB_USER

## update conda - warn : this takes a while
#RUN conda update -n base conda
#RUN conda update --all

## universal install
#RUN  conda  install -y     jupyter   matplotlib   numpy   pandas   scikit-learn   scipy   seaborn    tensorflow   && conda clean -tipsy
# RUN pip install  tensorboard

## create a python 3.6 env and install packages
RUN conda create -y -n py36 python=3.6 \
    numpy \
    scipy \
    pandas \
    scikit-learn \
    matplotlib \
    seaborn \
    jupyter \
    opencv \
    pillow \
    pytorch \
    torchvision \
    visdom \
    requests \
    moviepy \
    jsonpatch \
    chardet \ 
    idna \
    urllib3 \
    jsonpointer \
    tensorflow=1.10.0 \
    && conda clean -tipsy

# list envs
RUN conda info -e

## install tensorboard and torchnet with pip for py36
RUN /bin/bash -c "source activate py36 && \
    pip install  tensorboard && \
    pip install  torchnet && \
    source deactivate"

## ----- custom installs ----
USER root

RUN mkdir -p ${INSTALL_DIR}
## ---- install Oracle JDK -----
RUN wget -q 'https://s3.amazonaws.com/elephantscale-public/downloads/jdk-8u181-linux-x64.tar.gz' && \
    gunzip jdk-8u181-linux-x64.tar.gz && \
    tar -xf jdk-8u181-linux-x64.tar -C ${INSTALL_DIR} && \
    rm jdk-8u181-linux-x64.tar && \
    ln -s ${INSTALL_DIR}/jdk1.8.0_181 ${JAVA_HOME}


## --- BigDL and Analytics Zoo ------
ARG SCALA_VERSION=2.11.8
ARG BIGDL_VERSION=0.9.1
ARG ANALYTICS_ZOO_VERSION=0.9.1
ARG SPARK_VERSION=2.4.3
ARG SPARK_VERSION_BIGDL=2.4.0


## ----- install spark -------
ARG SPARK_DOWNLOAD_URL="https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop2.7.tgz"
RUN echo "Downloading Spark from : ${SPARK_DOWNLOAD_URL}"
RUN \
  curl -fsL  "${SPARK_DOWNLOAD_URL}"  | tar xfz - -C ${INSTALL_DIR} && \
  cd ${INSTALL_DIR} &&  rm -f spark && ln -s spark-${SPARK_VERSION}-bin-hadoop2.7  spark


## ----- install BigDL ----------
ARG BIGDL_URL=https://repo1.maven.org/maven2/com/intel/analytics/bigdl/dist-spark-${SPARK_VERSION_BIGDL}-scala-${SCALA_VERSION}-all/${BIGDL_VERSION}/dist-spark-${SPARK_VERSION_BIGDL}-scala-${SCALA_VERSION}-all-${BIGDL_VERSION}-dist.zip
RUN echo "Downloading BigDL from : ${BIGDL_URL}"
RUN \
    mkdir -p ${BIGDL_HOME} && \
    cd ${BIGDL_HOME} && \
    wget -q "${BIGDL_URL}"  && \
    unzip *.zip && \
    rm -f *.zip


# ---- install analytics zoo ----
COPY ./download-analytics-zoo.sh ${INSTALL_DIR}
RUN chmod a+x ${INSTALL_DIR}/download-analytics-zoo.sh
RUN cd ${INSTALL_DIR} && ./download-analytics-zoo.sh


## -------- setup env ---------
## disable sudo password
RUN echo "${NB_USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# this is where volumes will be mounted
RUN mkdir -p ${WORKING_DIR}

# create tensorboard logs dir
RUN mkdir -p ${TENSORBOARD_DIR}


## --- copy files last, so not to bust the cache ---
USER root
RUN mv /usr/local/bin/start-notebook.sh   /usr/local/bin/start-notebook-old.sh
COPY  start-notebook.sh  /usr/local/bin/
RUN chmod +x /usr/local/bin/start-notebook.sh

COPY ./run-jupyter-with-bigdl.sh  $HOME/
COPY ./run-jupyter-with-zoo.sh  $HOME/
RUN sudo chmod +x  $HOME/*.sh
RUN sudo chown $NB_USER  $HOME/*

## source python 3.6 when Bash shell starts
RUN echo  "\nsource activate py36\n" >> ~/.bashrc

## finally switch back to jovyan to avoid accidental container runs as root
USER $NB_USER
