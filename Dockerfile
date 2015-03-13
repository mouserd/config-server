FROM dockerfile/java:oracle-java8
MAINTAINER david.mouser@gmail.com
EXPOSE 8888
CMD java -jar config-server-1.0.0.RELEASE.jar
ADD target/config-server-1.0.0.RELEASE.jar /data/config-server-1.0.0.RELEASE.jar
