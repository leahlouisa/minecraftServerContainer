# minecraftServerContainer

This was a project I did to learn the basics of containers.  I would not recommend using it because there are way better options on Dockerhub.

All of the Java stuff is lifted straight out of https://hub.docker.com/r/anapsix/alpine-java/~/dockerfile/ .

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
