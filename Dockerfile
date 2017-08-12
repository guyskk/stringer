FROM ruby:2.3
COPY apt-sources.list /etc/apt/sources.list
RUN apt-get update && \
    apt-get install -y git libxml2-dev libxslt-dev libcurl4-openssl-dev \
        libpq-dev libsqlite3-dev build-essential postgresql libreadline-dev
COPY Gem* .ruby-version /project/
WORKDIR /project
RUN bundle config mirror.https://rubygems.org https://gems.ruby-china.org && \
    bundle install
VOLUME /project
CMD ["./start.rb", "app"]
