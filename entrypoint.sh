#!/bin/sh

mkdir -p /srv/freeciv
chown -R civ:civ /srv/freeciv
runuser -u civ -- \
	tmux new-session \
		-s civ \
		-d 'sh -c " \
			while true; \
			do \
				freeciv-server --saves /srv/freeciv --port 5556 | tee -a /srv/freeciv/server.log; \
			done \
			"'

freeciv_pid=''
while [ "$freeciv_pid" = '' ]
do
	freeciv_pid=$(pidof freeciv-server)
	echo "waiting for freeciv server to start ..."
	sleep 1
done

echo "Freeciv server started ($freeciv_pid)"
tail --pid=$freeciv_pid -f /srv/freeciv/server.log
