

## Console
mvn clean package  
mvn azure-functions:run

## Browser
http://localhost:7071/api/HttpExample?name=Functions

Press Ctrl+C (Command+C on macOS) to stop the host.

## Build the container image and verify locally

docker build --tag <DOCKER_ID>/azurefunctionsimage:v1.0.0 .

docker run -p 8080:80 -it <DOCKER_ID>/azurefunctionsimage:v1.0.0

## Publish the container image to a registry
az acr login --name <REGISTRY_NAME>
docker tag <DOCKER_ID>/azurefunctionsimage:v1.0.0 <LOGIN_SERVER>/azurefunctionsimage:v1.0.0
docker push <LOGIN_SERVER>/azurefunctionsimage:v1.0.0

