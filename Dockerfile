# Docker file for GoCD agent with the dependencies needed to
# build and test 10darts.
FROM gocd/gocd-agent-ubuntu-16.04:v17.11.0
MAINTAINER 10darts <it@10darts.com>
ENV LC_ALL C

# Packages required
RUN sed -i 's/main/main contrib/g' /etc/apt/sources.list
RUN apt-get update && apt-get install -y \
     software-properties-common
RUN apt-add-repository ppa:ansible/ansible
RUN apt-get update && apt-get install -y \
    software-properties-common \
    build-essential \
    libssl-dev \
    libpq-dev \
    libjpeg-dev \
    jpegoptim \
    optipng \
    gettext \
    gdal-bin \
    geoip-bin \
    geoip-database-contrib \
    geoipupdate \
    libffi-dev \
    curl \
    python3 \
    python3-dev \
    python3-pip \
    git \
    python-boto \
    ansible

# Install geoipupdate together with our licence key and config for it.
COPY ./GeoIP.conf /etc/GeoIP.conf
RUN geoipupdate -f /etc/GeoIP.conf -d /usr/share/GeoIP

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs

# Install Python packages.
RUN pip3 install tox virtualenv
