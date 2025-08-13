FROM ruby:3.3-slim

ENV BUNDLER_VERSION=2.5.17
# Paquetes para compilar gems (pg, bootsnap, etc.)
RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    build-essential git curl ca-certificates pkg-config \
    libpq-dev libssl-dev libyaml-dev zlib1g-dev libreadline-dev \
    tzdata \
 && gem update --system \
 && gem install bundler -v "$BUNDLER_VERSION" \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Instala gems del Gemfile (evita copiar todo el contexto aún)
COPY Gemfile Gemfile.lock ./
RUN bundle config set path '/usr/local/bundle' \
 && bundle config set jobs 4 \
 && bundle install

# Resto del proyecto
COPY . .
EXPOSE 3000
