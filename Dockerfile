ARG RUBY
FROM ruby:${RUBY}-alpine

# argumentos recebidos  atraves do docker-compose.yml
ARG USER_ID
ARG USER_NAME
ARG APP_NAME

ENV USER_ID $USER_ID

# Cria usuário e grupo baseado no host para evitar problemas com 
# permissão de arquivos gerados dentro do container (ex.: logs, novas migrations)
RUN mkdir /usr/src/${APP_NAME} \
  && addgroup ${USER_NAME} \
  && adduser -D -G ${USER_NAME} ${USER_NAME} -u $USER_ID -h /usr/src/${APP_NAME}

WORKDIR /usr/src/${APP_NAME}/

RUN mkdir -p tmp tmp/cache && chown -R ${USER_NAME} tmp
RUN apk add --no-cache ca-certificates libcurl libressl libxml2 libxslt \
  postgresql-libs postgresql-client tzdata g++ make

RUN set -ex && \
  apk add --no-cache --virtual build-base git \
  libxml2-dev libxslt-dev postgresql-dev libressl-dev

# Do the gem installation stuff first, in a separate step, because they
# Don't change as often as the code (so we can cache them in a separate 
# Docker image layer)
RUN chown ${USER_ID}.${USER_ID} -R $GEM_HOME
USER $USER_NAME

RUN gem install bundler

COPY --chown=${USER_NAME} Gemfile ./
COPY --chown=${USER_NAME} scripts/setup ./scripts/setup

RUN bundle install
