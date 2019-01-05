ARG buildtype

#
#   Stage 0: Get source code
#

FROM alpine:latest AS builder-base
ARG gitbranch

RUN apk update
RUN apk add git

WORKDIR /usr/src/app
RUN git clone --single-branch -b ${gitbranch} --depth 1 https://github.com/douglasdaly/douglasdaly.git .
RUN rm -rf .git

RUN apk del git


#
#   Stage 1 Base
#

FROM python:3.6-alpine AS builder-stage1

COPY --from=builder-base /usr/src/app /src
RUN pip install --upgrade pipenv

WORKDIR /src


#
#   Stage 1: Production
#

FROM builder-stage1 AS builder-production

COPY production.env /src/.env


#
#   Stage 1: Staging
#

FROM builder-stage1 AS builder-staging

COPY staging.env /src/.env


#
#   Stage 1: Debug
#

FROM builder-stage1 AS builder-debug

RUN touch .env


#
#   BUILD OUTPUT
#

FROM builder-${buildtype}
ARG buildtype

RUN apk update && \
    apk add --no-cache jpeg-dev zlib-dev freetype-dev lcms2-dev openjpeg-dev tiff-dev tk-dev tcl-dev && \
    apk add --no-cache --virtual build-deps gcc python3-dev musl-dev && \
    apk add --no-cache postgresql-dev && \
    apk add --no-cache make bash git

# - Assemble application
RUN make requirements

RUN if [ "$buildtype" = "debug" ]; then python scripts/new_secret_key.py && make debug_setup; fi

# - Cleanup
RUN apk del build-deps git

# - Entrypoint
ENTRYPOINT make start
