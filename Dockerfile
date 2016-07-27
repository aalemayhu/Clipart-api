FROM ubuntu
# Copied from: https://github.com/tcnksm-sample/docker-sinatra
MAINTAINER scanf "https://github.com/scanf"

# Install packages for building ruby
RUN apt-get update
RUN apt-get install -y --force-yes build-essential wget git ruby
RUN apt-get install -y --force-yes zlib1g-dev libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt-dev ruby-dev
RUN apt-get clean

RUN gem install eventmachine -v '1.2.0.1'
RUN gem update --system
RUN gem install bundler

RUN git clone https://github.com/tcnksm/docker-sinatra /root/sinatra
RUN cd /root/sinatra; bundle install

EXPOSE 4567
CMD ["/usr/local/bin/foreman","start","-d","/root/sinatra"]
