FROM ubuntu:trusty

MAINTAINER Stephan Lindauer

apt-get -y update
apt-get -y upgrade

apt-get -y install ruby wget build-essential

cd /jruby
wget https://s3.amazonaws.com/jruby.org/downloads/1.7.24/jruby-bin-1.7.24.tar.gz
tar -xzvf jruby-bin-1.7.24.tar.gz

RUN cd ruby-install-0.5.0/
RUN make install
RUN ruby-install jruby 1.7.9



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
