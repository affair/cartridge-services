# cartridge-services
An example of how to run a Cartridge application project in Docker. 
# The challenge
Create a boilerplate with MC(Model+Controller) architecture for Tarantool-Cartridge applications you can use for development and production
# Prerequisites
* [Docker](https://www.docker.com/get-started)
* [Docker Compose](https://docs.docker.com/compose/)
# Getting Started
```
# Get the latest snapshot
git clone https://github.com/affair/cartridge-services.git
# Change directory
cd cartridge-services
# Launch the project
docker-compose up -d
```
# App Structure
* ./nginx - revrse proxy to forward requests to the specific service
* ./<service_name> - List of services
* ./<service_name>/app/libs/db.lua - The main db class. It initializes all models.
* ./<service_name>/app/controllers - RESTful route declarations using cartridge httpd module
* ./<service_name>/app/models - List of Models