FROM ubuntu:trusty

MAINTAINER Stephan Lindauer

RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install build-essential wget git zlib1g-dev libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt-dev
RUN apt-get clean

RUN wget http://cache.ruby-lang.org/pub/ruby/2.3/ruby-2.3.0.tar.gz
RUN echo "ba5ba60e5f1aa21b4ef8e9bf35b9ddb57286cb546aac4b5a28c71f459467e507 ruby-2.3.0.tar.gz" | sha256sum -c
RUN tar -xzvf ruby-2.3.0.tar.gz
RUN rm ruby-2.3.0.tar.gz

WORKDIR /ruby-2.3.0
RUN ./configure; make install

RUN gem update --system
RUN gem install bundler

ADD . /criticalmaps-api
WORKDIR /criticalmaps-api
RUN bundle install

EXPOSE 4567

CMD ["ruby", "/criticalmaps-api/config.ru"]

























#
#
#
#
#
#
# RUN apt-get -y install build-essential git
#
# ENV PATH /rbenv/bin:$PATH
#
# RUN git clone https://github.com/rbenv/rbenv.git /rbenv
# RUN git clone https://github.com/rbenv/ruby-build.git /rbenv/plugins/ruby-build
# RUN eval "$(rbenv init -)"
# RUN cd /rbenv/plugins/ruby-build/; pwd; ./install.sh
# RUN	echo 'gem: --no-rdoc --no-ri' >> /etc/gemrc
#
# RUN mkdir /app
# COPY . /app
# WORKDIR /app
#
# RUN rbenv install
# RUN gem install bundler
# RUN bundle install
#
# EXPOSE 5000
#
# ENTRYPOINT ["bash"]
#
# CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "5000"]
