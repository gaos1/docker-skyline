FROM ubuntu

MAINTAINER Jason Carver <ut96caarrs@snkmail.com>

#The command order is intended to optimize for least-likely to change first, to speed up builds
RUN    mkdir /var/log/skyline \
    && mkdir /var/run/skyline \
    && mkdir /var/log/redis \
    && mkdir /var/dump

RUN    apt-get update \
    && apt-get install -y git python-setuptools python-dev \
    && apt-get clean
RUN easy_install pip

#Need sudo as a NOOP
RUN apt-get install -y sudo

#Redis
RUN    apt-get install -y wget \
    && wget http://download.redis.io/releases/redis-2.6.16.tar.gz \
    && tar --extract --gzip --directory /opt --file redis-2.6.16.tar.gz \
    && apt-get install -y gcc build-essential \
    && cd /opt/redis-2.6.16 \
    && make

ENV PATH $PATH:/opt/redis-2.6.16/src

#numpy needs python build tools
RUN pip install numpy

#scipy requires universe
RUN apt-get update \
    && apt-get install -y python-scipy \
    && apt-get clean

RUN pip install pandas
RUN pip install patsy
RUN pip install statsmodels
RUN pip install msgpack-python

RUN git clone https://github.com/etsy/skyline.git /opt/skyline

RUN pip install -r /opt/skyline/requirements.txt

RUN cp /opt/skyline/src/settings.py.example /opt/skyline/src/settings.py

#security updates
RUN apt-get upgrade -y

ADD skyline-start.sh /skyline-start.sh
RUN chmod +x skyline-start.sh

ADD skyline-settings.py /opt/skyline/src/settings.py

WORKDIR /opt/skyline/bin

ENTRYPOINT ["/skyline-start.sh"]

#skyline webserver port
EXPOSE :1500

#graphite collection port
EXPOSE :2024
