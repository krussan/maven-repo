#!/bin/sh
REPOSITORY=$GIT_BASE/maven-repo
POMFILE=$1
JARFILE=$2

echo $POMFILE
echo $JARFILE

GROUPID=`sed -e "s/xmlns/ignore/" $POMFILE  | xmllint --xpath '/project/groupId/text()' -`
ARTIFACTID=`sed -e "s/xmlns/ignore/" $POMFILE  | xmllint --xpath '/project/artifactId/text()' -`
VERSION=`echo $JARFILE | sed 's/.jar//' | sed 's/[[:alpha:]|(|[:space:]|-]//g'`
PACKAGING=`sed -e "s/xmlns/ignore/" $POMFILE  | xmllint --xpath '/project/packaging/text()' -`

echo $GROUPID
echo $ARTIFACTID
echo $VERSION
echo $PACKAGING


mvn install:install-file -Dfile=$JARFILE -DgroupId=$GROUPID -DartifactId=$ARTIFACTID -Dversion=$VERSION -Dpackaging=$PACKAGING -DlocalRepositoryPath=$REPOSITORY


MVNPATH=`echo $GROUPID | sed -e "s/\./\//g"`
MVNPATH=$MVNPATH/$ARTIFACTID

echo $MVNPATH

mv $REPOSITORY/$MVNPATH/maven-metadata-local.xml $REPOSITORY/$MVNPATH/maven-metadata.xml
