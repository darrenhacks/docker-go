.DEFAULT_GOAL := docker-go

docker-go: main.go
	go build -o docker-go

clean:
	rm docker-go
