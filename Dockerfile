FROM alpine:3.13 as base
RUN sed -i -e 's|^\(.*\)v3.13/main|@edge-testing \1edge/testing\n&|' /etc/apk/repositories

RUN apk add --no-cache freeciv-server@edge-testing runuser tmux coreutils
RUN adduser -D -g civ civ

EXPOSE 5556

VOLUME /srv/

COPY entrypoint.sh /

CMD /entrypoint.sh
