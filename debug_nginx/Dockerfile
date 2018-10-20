FROM nginx:alpine

RUN rm /etc/nginx/conf.d/default.conf

RUN apk add --no-cache bash

COPY douglasdaly.conf /etc/nginx/conf.d/
