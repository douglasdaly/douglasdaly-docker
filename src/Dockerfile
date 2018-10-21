#
# Stage 1: Get source code
#

FROM alpine:latest AS builder

RUN apk update
RUN apk add git

WORKDIR /usr/src/app
RUN git clone https://github.com/douglasdaly/douglasdaly.git .
RUN rm -rf .git

RUN apk del git


#
# Stage 2: Build image
#

FROM python:3.6-alpine

RUN apk update && \
    apk add --no-cache jpeg-dev zlib-dev freetype-dev lcms2-dev openjpeg-dev tiff-dev tk-dev tcl-dev && \
    apk add --no-cache --virtual build-deps gcc python-dev musl-dev && \
    apk add --no-cache postgresql-dev && \
    apk add --no-cache make bash git

# - Assemble application

COPY --from=builder /usr/src/app /src

WORKDIR /src
ADD .env .

RUN mkdir logs/
RUN make requirements

# - Cleanup
RUN apk del build-deps git

# - Entrypoint

ENTRYPOINT ["make", "start"]
