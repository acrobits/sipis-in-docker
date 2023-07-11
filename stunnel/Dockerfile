FROM debian:bookworm
RUN apt-get update \
    && apt-get install -y --no-install-recommends ssl-cert stunnel4 \
    && rm -rf /var/lib/apt/lists/*
COPY stunnel.conf /stunnel.conf
EXPOSE 443
CMD ["/usr/bin/stunnel", "/stunnel.conf"]

