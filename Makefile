build:
	docker build -t tadayosi/artemis:ssl .

run:
	docker run --rm -p 8161:8161 -p 8778:8778 -p 61616:61616 --name artemis tadayosi/artemis:ssl

run-daemon:
	docker run --rm -d -p 8161:8161 -p 8778:8778 -p 61616:61616 --name artemis tadayosi/artemis:ssl

push:
	docker push tadayosi/artemis:ssl

deploy-openshift:
	-oc delete deploy/artemis
	oc create deploy artemis --image=tadayosi/artemis:ssl
	oc patch deploy artemis -p '{"spec":{"template":{"spec":{"containers":[{"name":"artemis","imagePullPolicy": "Always","ports":[{"containerPort":8161,"name":"console-jolokia","protocol":"TCP"},{"containerPort":8778,"name":"jolokia","protocol":"TCP"},{"containerPort":61616,"name":"artemis","protocol":"TCP"}]}]}}}}'
