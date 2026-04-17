BIN := spaces-publisher

.PHONY: build install fmt test

build:
	go build -o $(BIN) .

install:
	go install .

fmt:
	gofmt -w *.go

test:
	go test ./...
