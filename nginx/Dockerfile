ARG cert_type

#
#   Existing Certificate Build
#

FROM nginx:alpine AS build-static
ARG cert_file
ARG cert_key

COPY ${cert_file} /etc/letsencrypt/live/www.douglasdaly.com/fullchain.pem
COPY ${cert_key} /etc/letsencrypt/live/www.douglasdaly.com/privkey.pem

RUN rm /etc/nginx/conf.d/default.conf


#
#   Lets Encrypt Build
#

FROM staticfloat/nginx-certbot AS build-letsencrypt


#
#   Build Output
#

FROM build-${cert_type}
ARG nginxconf

COPY $nginxconf /etc/nginx/conf.d/