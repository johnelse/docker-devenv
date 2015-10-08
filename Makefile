all: build

build:
	@docker build -t ${USER}/devenv .
