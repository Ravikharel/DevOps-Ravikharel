# A basic nginx container 

A nginx contianer that serves a static index.html 

## How to start container
```bash 
docker image build -t <image_name:version> . 
docker container run -d -p 8080:80 --name nginx-container <image_name:version>

