FROM aflmedia/debian-jre8:latest
MAINTAINER david.mouser@gmail.com

EXPOSE 8888

ADD build/config-server.jar /data/config-server.jar
CMD java -jar /data/config-server.jar
