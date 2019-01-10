ARG cert_type

#
#   No Certificate Build
#

FROM nginx:alpine as build-nocert

RUN rm /etc/nginx/conf.d/default.conf
COPY www.douglasdaly-nocert.conf /etc/nginx/conf.d/www.douglasdaly.conf


#
#   Existing Certificate Build
#

FROM nginx:alpine AS build-static
ARG cert_file
ARG cert_key

COPY ${cert_file} /etc/certs/www.douglasdaly.com/fullchain.pem
COPY ${cert_key} /etc/certs/www.douglasdaly.com/privkey.pem

RUN rm /etc/nginx/conf.d/default.conf
COPY www.douglasdaly-static.conf /etc/nginx/conf.d/www.douglasdaly.conf


#
#   Lets Encrypt Build
#

FROM staticfloat/nginx-certbot AS build-letsencrypt
COPY www.douglasdaly-letsencrypt.conf /etc/nginx/conf.d/www.douglasdaly.conf


#
#   Build Output
#

FROM build-${cert_type}
COPY startup_sleep.sh /scripts/startup/startup_sleep.sh