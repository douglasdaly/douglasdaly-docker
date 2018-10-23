FROM nginx:alpine
ARG buildtype
ARG nginxconf

RUN rm /etc/nginx/conf.d/default.conf

RUN if [ "$buildtype" != "production" ]; then apk add --no-cache bash; fi

COPY $nginxconf /etc/nginx/conf.d/
