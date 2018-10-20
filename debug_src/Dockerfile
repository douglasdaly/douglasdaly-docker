# Stage 0: Builder container

FROM alpine:latest AS builder

RUN apk add --no-cache git

WORKDIR /usr/src/app

RUN git clone https://github.com/douglasdaly/douglasdaly.git .
RUN rm -rf .git

RUN apk del git

# Application Container

FROM python:3.6-alpine

# - Get necessary packages

RUN apk update
RUN apk add --no-cache jpeg-dev zlib-dev freetype-dev lcms2-dev openjpeg-dev tiff-dev tk-dev tcl-dev
RUN apk add --no-cache make bash git
RUN apk add --no-cache --virtual build-deps gcc python3-dev musl-dev && \
    apk add --no-cache postgresql-dev 

# - Assemble application

COPY --from=builder /usr/src/app /src

WORKDIR /src
RUN touch .env
RUN mkdir logs/

RUN make requirements
RUN python scripts/new_secret_key.py
RUN make debug_setup

# - Cleanup
RUN apk del git
RUN apk del build-deps

# - Entrypoint

ENTRYPOINT ["make", "debug"]