
IMAGE_NAME = s2i-maven-builder

build:
	docker build -t $(IMAGE_NAME) .

.PHONY: test
test:
	docker build -t $(IMAGE_NAME)-candidate .
	IMAGE_NAME=$(IMAGE_NAME)-candidate BUILDER=maven TEST_DIR=test-app-with-asis test/run
