COMPOSE_FILE=docker-compose.yml

.PHONY: start
start:
	docker-compose -f ${COMPOSE_FILE} up

.PHONY: stop
stop:
	docker-compose -f ${COMPOSE_FILE} down

.PHONY: restart
restart:
	docker-compose -f ${COMPOSE_FILE} stop
	docker-compose -f ${COMPOSE_FILE} up

.PHONY: rebuild
rebuild:
	docker-compose -f ${COMPOSE_FILE} stop
	docker-compose -f ${COMPOSE_FILE} up --build --force-recreate	