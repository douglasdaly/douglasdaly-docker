FROM python:3.5-alpine

RUN apk update
RUN apk add jpeg-dev zlib-dev freetype-dev lcms2-dev openjpeg-dev tiff-dev tk-dev tcl-dev
RUN apk add --virtual build-deps gcc python-dev musl-dev && \
    apk add postgresql-dev 
RUN apk add make git bash
RUN rm -rf /var/cache/apk/*

RUN mkdir /src/
WORKDIR /src/

RUN git clone https://github.com/douglasdaly/douglasdaly.git .
ADD .env /src/

RUN mkdir /src/logs/

RUN make requirements

ENTRYPOINT ["make", "start"]
