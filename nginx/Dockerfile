ARG buildtype

#
#   Debug Image
#

FROM nginx:alpine AS build-debug

RUN apk add --no-cache bash

RUN rm /etc/nginx/conf.d/default.conf


#
#   Staging Image
#

FROM staticfloat/nginx-certbot AS build-staging


#
#   Production Image
#

FROM staticfloat/nginx-certbot AS build-production


#
#   BUILD OUTPUT IMAGE
#

FROM build-${buildtype}
ARG nginxconf

COPY $nginxconf /etc/nginx/conf.d/
