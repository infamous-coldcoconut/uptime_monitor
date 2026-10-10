# syntax=docker/dockerfile:1
ARG RUBY_VERSION=4.0.7
FROM ruby:${RUBY_VERSION}-slim

# Instalace závislostí pro kompilaci gemů a PostgreSQL klienta
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    libpq-dev \
    curl \
    git && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /rails

# Instalace gemů (včetně development skupiny)
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Zkopírování kódu aplikace
COPY . .

# Oprava konců řádků pro skripty vytvořené na Windows (CRLF -> LF)
RUN chmod +x bin/* && \
    sed -i "s/\r$//g" bin/* && \
    sed -i "s/ruby\.exe/ruby/g" bin/*

EXPOSE 3000

CMD ["sh", "-c", "bin/rails db:prepare && bin/rails runner \"load Rails.root.join('db/queue_schema.rb')\" && bin/rails server -b 0.0.0.0 -p ${PORT:-3000}"]