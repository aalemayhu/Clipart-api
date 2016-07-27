all:
	ruby app.rb -o 0.0.0.0

build-docker:
	docker build -t sinatra .

run-docker: clean build-docker
	docker run -p 4567:4567 -d sinatra

clean:
	./docker-clean
