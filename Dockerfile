FROM ubuntu:trusty

MAINTAINER Stephan Lindauer <stephanlindauer@posteo.de>

RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install build-essential wget git zlib1g-dev libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt-dev
RUN apt-get clean

RUN wget http://cache.ruby-lang.org/pub/ruby/2.2/ruby-2.2.3.tar.gz
RUN echo "df795f2f99860745a416092a4004b016ccf77e8b82dec956b120f18bdc71edce ruby-2.2.3.tar.gz" | sha256sum -c
RUN tar -xzvf ruby-2.2.3.tar.gz
RUN rm ruby-2.2.3.tar.gz

WORKDIR /ruby-2.2.3
ENV CONFIGURE_OPTS --disable-install-rdoc
RUN ./configure; make install

RUN gem update --system
RUN gem install bundler


EXPOSE 4567

ADD . /criticalmaps-api
WORKDIR /criticalmaps-api
RUN bundle install

CMD ["foreman","start","-d","/criticalmaps-api"]
