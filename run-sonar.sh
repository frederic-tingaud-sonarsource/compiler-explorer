#!/usr/bin/env bash

java -cp \
	##SONAR_CPP##/sonar-cfamily-plugin/analyzer/build/libs/analyzer-*-SNAPSHOT.jar \
	com.sonar.cpp.plugin.StandaloneSensor \
        --json \
        --subprocess ##SUBPROCESS## \
	"$@"
