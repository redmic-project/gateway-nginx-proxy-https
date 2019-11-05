ARG NGINX_IMAGE_TAG=1.17-alpine

FROM nginx:${NGINX_IMAGE_TAG}

LABEL maintainer="info@redmic.es"

COPY nginx /etc/nginx
COPY scripts/entrypoint.sh /entrypoint.sh

ARG OPENSSL_VERSION=1.1.1d-r0
RUN apk add --no-cache \
	openssl=${OPENSSL_VERSION}

EXPOSE 443

HEALTHCHECK --interval=30s --timeout=15s --start-period=1m --retries=10 \
	CMD wget --spider -q https://localhost/nginx-health \
		|| (count=$(ps aux | grep openssl | wc -l); [ ${count} -gt 1 ]) \
		|| exit 1

CMD ["sh", "-c", "/entrypoint.sh"]
