FROM nginx:alpine

LABEL maintainer="info@redmic.es"

COPY nginx /etc/nginx

COPY scripts/entrypoint.sh /entrypoint.sh

RUN apk add --no-cache openssl

CMD ["sh", "-c", "/entrypoint.sh"]
