#!/bin/sh

if [[ ! $MAVEN_VERSION ]]
then
	MAVEN_VERSION=maven:3.6.3-jdk-8
fi

echo Build with $MAVEN_VERSION;
MSYS_NO_PATHCONV=1 docker run -it --rm -v $(pwd):/project -v $(echo $M2_HOME):/root/.m2 -w /project $MAVEN_VERSION mvn $@;
