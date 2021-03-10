default: start

build:
	docker build -t freeciv .

start: build
	docker run --name freeciv -d --rm -p 5556:5556 freeciv

stop:
	docker stop freeciv

logs:
	docker logs -f freeciv
