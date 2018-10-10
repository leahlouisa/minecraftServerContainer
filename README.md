# minecraftServerContainer

This was a project I did to learn the basics of containers.  I would not recommend using it because there are way better options on Dockerhub.

All of the Java stuff is lifted straight out of https://hub.docker.com/r/anapsix/alpine-java/~/dockerfile/ .
This was also helpful: https://medium.com/felixklauke/paperspigot-in-docker-containerized-minecraft-server-d34e35e3ee3c

## Docker Stuff

To build:
docker build -t continuumminecraft .

To run:
docker run -d -p 25565:25565 --name continuum -it -v <location/on/your/filesystem>:/data continuumminecraft:latest

To start:
docker start --interactive continuum

To stop:
docker stop continuum

To attach:
docker attach continuum

To escape from interactive mode:
Control-p Control-q

## Setup

Use this guide to install Docker on AWS
https://docs.aws.amazon.com/AmazonECS/latest/developerguide/docker-basics.html#install_docker

Make Docker Daemon start on server boot:
sudo systemctl enable docker
(disable to disable)
