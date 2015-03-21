#!/bin/sh
APP_NAME=$1
ENVIRONMENT=$2
S3_BUCKET="elasticbeanstalk-ap-southeast-2-198704433614"
DOCKER_SOLUTION_STACK="64bit Amazon Linux 2014.09 v1.2.0 running Docker 1.3.3"
CWD_NAME=${PWD##*/}

usage() {

  echo "[ERROR] Invalid/missing args"
  echo ""
  echo "Usage: $0 applicationName environment"
  echo "Deploys the applicationName to AWS Elastic Beanstalk for the given environment"

  exit
}

verify_return_code() {

  RETURN=$1

  if [ $RETURN -ne 0 ]; then
     echo "[ERROR] Error!"
     exit 1
  fi
}

start() {

  set_work_dir

  build

  prepare_artifacts

  upload
}

set_work_dir() {

  if [ "$CWD_NAME" == "$APP_NAME" ]; then
    echo "[INFO] Already in application diretory"
  else
    echo "[INFO] Changing to $APP_NAME sub-directory"
    cd $APP_NAME
    verify_return_code $?
  fi
}

build() {

  mvn clean install -s ~/.m2/settings-no-nexus.xml
  verify_return_code $?
}


prepare_artifacts() {

  rm -rf build/*.jar
  rm -rf build/*.zip
  cp target/$APP_NAME.jar build
  zip build/$APP_NAME.zip Dockerfile build/$APP_NAME.jar
  verify_return_code $?
}

upload() {

  GIT_COMMIT_HASH=`git rev-parse --short HEAD`

  echo "[INFO] Deleting AWS Beanstalk application version $GIT_COMMIT_HASH"
  aws elasticbeanstalk delete-application-version \
    --application-name "$APP_NAME" \
    --version-label "$GIT_COMMIT_HASH" \
    --delete-source-bundle
  verify_return_code $?

  echo "[INFO] Uploading zip to AWS S3 (s3://$S3_BUCKET/$APP_NAME-$GIT_COMMIT_HASH.zip)"
  aws s3 cp build/$APP_NAME.zip s3://$S3_BUCKET/$APP_NAME-$GIT_COMMIT_HASH.zip
  verify_return_code $?

  echo "[INFO] Creating AWS Beanstalk application version $GIT_COMMIT_HASH"
  aws elasticbeanstalk create-application-version \
    --application-name "$APP_NAME" \
    --version-label "$GIT_COMMIT_HASH" \
    --source-bundle S3Bucket="$S3_BUCKET",S3Key="$APP_NAME-$GIT_COMMIT_HASH.zip"
   verify_return_code $?


  AWS_ENV=`aws elasticbeanstalk describe-environments --application-name "$APP_NAME" --environment-name "$ENVIRONMENT"`
  ENV_LENGTH=${#AWS_ENV}
  echo "ENV LENGTH: $ENV_LENGTH"

  if [ $ENV_LENGTH -eq 0 ]; then
    echo "[INFO] Creating AWS Beanstalk application '$ENVIRONMENT' environment"
    aws elasticbeanstalk create-environment \
      --application-name="$APP_NAME" \
      --environment-name "$ENVIRONMENT" \
      --solution-stack "$DOCKER_SOLUTION_STACK" \
      --version-label "$GIT_COMMIT_HASH"
    verify_return_code $?
  else
    echo "[INFO] Updating AWS Beanstalk application '$ENVIRONMENT' environment"
    aws elasticbeanstalk update-environment \
      --environment-name "$ENVIRONMENT" \
      --version-label "$GIT_COMMIT_HASH"
    verify_return_code $?
  fi
}

  if [ "$#" -ne 2 ]; then
    usage
    exit 1
  fi

  start
exit 0
