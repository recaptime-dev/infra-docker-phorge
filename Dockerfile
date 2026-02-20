FROM alpine:3.21

EXPOSE 80 443 22 2222
COPY baseline /baseline
RUN /baseline/setup.sh

COPY preflight /preflight
RUN /preflight/setup.sh

CMD ["/bin/bash", "/app/init.sh"]
