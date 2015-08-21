## -*- docker-image-name: "OMV - OpenMediaVault" -*-
FROM debian:wheezy

MAINTAINER pr_bond <bond_jd@yahoo.fr>

EXPOSE 22 80 443

# Install OMV
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y wget locales

RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8 

RUN echo "deb http://packages.openmediavault.org/public stoneburner main" | tee -a /etc/apt/sources.list.d/openmediavault.list \
 && wget -O - http://packages.openmediavault.org/public/archive.key | apt-key add - \
 && apt-get update \
 && apt-get install -y --force-yes \
    openmediavault-keyring \
    postfix \
 && apt-get clean
 
# Install resolvconf (https://github.com/docker/docker/issues/1297)
RUN apt-get install -y --force-yes resolvconf; rm -f /var/lib/dpkg/info/resolvconf.postinst; dpkg --configure resolvconf 

# Failed to fetch cron-apt Hash Sum mismatch
RUN apt-get install -y --force-yes cron-apt
 
# Install openmediavault dependencies
RUN apt-get install -y --force-yes \
    $(apt-cache depends openmediavault | awk '/Depends:/{print$2}' | grep -v '<') \
 && apt-get clean

# Install openmediavault
RUN apt-get install -y --force-yes \
        openmediavault \
 && apt-get clean


# Install OMV extra plugins
RUN echo "deb http://packages.omv-extras.org/debian/ stoneburner main" >> /etc/apt/sources.list.d/omv-extras-org-stoneburner.list \
 && apt-get update \
 && apt-get install openmediavault-omvextrasorg -y --force-yes


# Enable SSH
RUN omv-config -m services/ssh/enable '"1"'

RUN service ssh start

RUN service php5-fpm start

RUN service nginx start

RUN service openmediavault-engined start

RUN service rrdcached start

RUN service collectd start

# run
RUN /bin/bash
