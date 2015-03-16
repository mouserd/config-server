#!/bin/sh

mvn clean install
cp target/config-server.jar build
zip build/config-server.zip Dockerfile build/config-server.jar

aws elasticbeanstalk delete-application-version --application-name "config-server" --version-label `git rev-parse --short HEAD` --delete-source-bundle

aws s3 cp build/config-server.zip s3://elasticbeanstalk-ap-southeast-2-198704433614/config-server-`git rev-parse --short HEAD`.zip

aws elasticbeanstalk create-application-version \
  --application-name "config-server" \
  --version-label `git rev-parse --short HEAD` \
  --source-bundle S3Bucket="elasticbeanstalk-ap-southeast-2-198704433614",S3Key="config-server-`git rev-parse --short HEAD`.zip"

#aws elasticbeanstalk create-environment \
#  --application-name="config-server" \
#  --environment-name "development" \
#  --solution-stack "64bit Amazon Linux 2014.09 v1.2.0 running Docker 1.3.3" \
#  --version-label `git rev-parse --short HEAD`

aws elasticbeanstalk update-environment \
  --environment-name "development" \
  --version-label `git rev-parse --short HEAD`