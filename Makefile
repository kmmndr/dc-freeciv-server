default: start

build:
	docker build -t freeciv .

start: build
	docker run --name freeciv -d --rm -p 5556:5556 freeciv

stop:
	-docker rm -f freeciv

logs:
	docker logs -f freeciv

console:
	docker exec -it freeciv runuser -u civ -- tmux attach
