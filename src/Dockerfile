#
# Stage 0: Get source code
#

FROM alpine:latest AS builder
ARG gitbranch

RUN apk update
RUN apk add git

WORKDIR /usr/src/app
RUN git clone --single-branch -b ${gitbranch} https://github.com/douglasdaly/douglasdaly.git .
RUN rm -rf .git

RUN apk del git


#
# Stage 1: Build image
#

FROM python:3.6-alpine
ARG startcmd
ENV START_COMMAND=$startcmd

RUN apk update && \
    apk add --no-cache jpeg-dev zlib-dev freetype-dev lcms2-dev openjpeg-dev tiff-dev tk-dev tcl-dev && \
    apk add --no-cache --virtual build-deps gcc python3-dev musl-dev && \
    apk add --no-cache postgresql-dev && \
    apk add --no-cache make bash git

# - Assemble application

COPY --from=builder /usr/src/app /src

WORKDIR /src

RUN mkdir logs/
RUN make requirements

RUN if [ "$startcmd" = "debug" ]; then \
        touch .env && \
        python scripts/new_secret_key.py && \
        make debug_setup; \
    fi

# - Cleanup
RUN apk del build-deps git

# - Entrypoint
ENTRYPOINT make $START_COMMAND
