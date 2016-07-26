FROM ubuntu

MAINTAINER scanf "https://github.com/scanf"

# Install packages for building ruby
RUN apt-get update
RUN apt-get install -y --force-yes build-essential wget git ruby
RUN apt-get install -y --force-yes zlib1g-dev libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt-dev
RUN apt-get clean

RUN gem update --system
RUN gem install bundler

RUN git clone https://github.com/tcnksm/docker-sinatra /root/sinatra
RUN cd /root/sinatra; bundle install

EXPOSE 4567
CMD ["/usr/local/bin/foreman","start","-d","/root/sinatra"]