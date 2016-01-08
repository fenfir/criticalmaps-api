FROM ubuntu

MAINTAINER Stephan Lindauer

RUN apt-get -y update
RUN apt-get -y upgrade

RUN apt-get -y install build-essential git

ENV PATH /rbenv/bin:$PATH

RUN git clone https://github.com/rbenv/rbenv.git /rbenv
RUN git clone https://github.com/rbenv/ruby-build.git /rbenv/plugins/ruby-build
RUN eval "$(rbenv init -)"
RUN cd /rbenv/plugins/ruby-build/; pwd; ./install.sh
RUN	echo 'gem: --no-rdoc --no-ri' >> /etc/gemrc

RUN mkdir /app
COPY . /app
WORKDIR /app

RUN rbenv install
RUN gem install bundler
RUN bundle install

EXPOSE 5000

ENTRYPOINT ["bash"]

CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "5000"]
