# cicd-learning

### Deploying to Fly.io

Guide: https://medium.com/@vergil333/deploy-spring-boot-to-fly-iof-d54d5ca05243

- Need to create a docker file 
  - Testing the docker file: starting hte docker deamon on mac means starting docker desktop: 
  - `open -a Docker`
  - Then you can run the following command: `docker buildx build --platform linux/amd64 --tag cicdtraining:latest .`
  - Don't forget the '.' at the end. It is for the PATH variable, most likely wehre the docker file is located
  - To run the image: `docker run -p 8001:8080 cicdtraining:latest`. The -p is for publishing the port on the container 
    to local machine

##### Fly.io itself

https://fly.io/docs/getting-started/launch-demo/

FYI: flyctl was installed using brew / homebrew 
Created an account using github: nicholas@aboutcoding.be
used the command: fly auth signup

Deploying an app: 

https://fly.io/docs/launch/create/ 




