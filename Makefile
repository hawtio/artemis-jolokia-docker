ORG := tadayosi
TAG := latest

build:
	docker build -t $(ORG)/artemis:$(TAG) .

run:
	docker run --rm -p 8161:8161 -p 8778:8778 -p 61616:61616 --name artemis $(ORG)/artemis:$(TAG)

run-daemon:
	docker run --rm -d -p 8161:8161 -p 8778:8778 -p 61616:61616 --name artemis $(ORG)/artemis:$(TAG)

push:
	docker push $(ORG)/artemis:$(TAG)

deploy-openshift:
	-oc delete deploy/artemis
	oc create deploy artemis --image=docker.io/$(ORG)/artemis:$(TAG)
	oc patch deploy artemis -p '{"spec":{"template":{"spec":{"containers":[{"name":"artemis","imagePullPolicy": "Always","ports":[{"containerPort":8161,"name":"console-jolokia","protocol":"TCP"},{"containerPort":8778,"name":"jolokia","protocol":"TCP"},{"containerPort":61616,"name":"artemis","protocol":"TCP"}]}]}}}}'
