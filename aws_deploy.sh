#!/bin/sh
APP_NAME="config-server"
ENVIRONMENT="development"
S3_BUCKET="elasticbeanstalk-ap-southeast-2-198704433614"
GIT_COMMIT_HASH=`git rev-parse --short HEAD`

mvn clean install
cp target/config-server.jar build
zip build/config-server.zip Dockerfile build/config-server.jar

aws elasticbeanstalk delete-application-version --application-name $APP_NAME --version-label $GIT_COMMIT_HASH --delete-source-bundle

aws s3 cp build/config-server.zip s3://$S3_BUCKET/$APP_NAME-$GIT_COMMIT_HASH.zip

aws elasticbeanstalk create-application-version \
  --application-name "$APP_NAME" \
  --version-label `git rev-parse --short HEAD` \
  --source-bundle S3Bucket="$S3_BUCKET",S3Key="$APP_NAME-$GIT_COMMIT_HASH.zip"

aws elasticbeanstalk update-environment \
  --environment-name $ENVIRONMENT \
  --version-label $GIT_COMMIT_HASH