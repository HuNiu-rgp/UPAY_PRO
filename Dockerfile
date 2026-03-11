FROM alpine:3.22

ARG RELEASE_URL="https://github.com/HuNiu-rgp/UPAY_PRO/releases/download/v1.0.0/upay_pro.zip"

RUN apk add --no-cache ca-certificates tzdata curl unzip redis

WORKDIR /app

RUN curl -L "${RELEASE_URL}" -o /tmp/upay_pro.zip \
	&& unzip /tmp/upay_pro.zip -d /app \
	&& rm -f /tmp/upay_pro.zip \
	&& rm -rf /app/__MACOSX \
	&& rm -f /app/upay_pro/.DS_Store \
	&& chmod +x /app/upay_pro/upay_pro \
	&& mkdir -p /app/upay_pro/logs /app/upay_pro/DBS

COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /app/upay_pro

VOLUME ["/app/upay_pro/logs", "/app/upay_pro/DBS"]

EXPOSE 8090

ENTRYPOINT ["/entrypoint.sh"]
