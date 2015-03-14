FROM dockerfile/java:oracle-java8
MAINTAINER david.mouser@gmail.com
EXPOSE 8888
CMD java -jar config-server.jar
ADD build/config-server.jar /data/config-server.jar
