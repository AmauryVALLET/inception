all: makedir build up

makedir:
	mkdir -p /home/amaury/data/mariadb
	mkdir -p /home/amaury/data/wordpress

build:
	sudo docker-compose -f srcs/docker-compose.yml build

up:
	sudo docker-compose -f srcs/docker-compose.yml up -d

down:
	sudo docker-compose -f srcs/docker-compose.yml down

clean:
	sudo docker-compose -f srcs/docker-compose.yml down --volumes --remove-orphans

fclean: clean
	@sudo docker system prune -af
	@sudo rm -rf /home/amaury/data/mariadb /home/amaury/data/wordpress
	
re: clean all

.PHONY: build up all re clean fclean down makedir