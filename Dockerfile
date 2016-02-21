FROM ubuntu:trusty

MAINTAINER Stephan Lindauer

RUN apt-get -y install wget
RUN apt-get -y install software-properties-common

RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections

RUN apt-add-repository ppa:brightbox/ruby-ng
RUN add-apt-repository ppa:webupd8team/java
RUN apt-get -y update

RUN apt-get -y install oracle-java8-installer

RUN wget https://s3.amazonaws.com/jruby.org/downloads/9.0.5.0/jruby-bin-9.0.5.0.tar.gz
RUN tar -xzvf jruby-bin-9.0.5.0.tar.gz
RUN rm jruby-bin-9.0.5.0.tar.gz

ENV JRUBY_HOME '/jruby-9.0.5.0'
ENV PATH $JRUBY_HOME/bin:$PATH


# CMD ["puma", "--port", "80"]

























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
