#!/bin/bash
commonJenkinsHOME=$1
thisJenkinsHOME=$2
release=$3
version=$4

targetPath=$HUDSON_HOME/jobs/${JOB_NAME}/workspace/target/rampapi.war
resourcePath=$HUDSON_HOME/jobs/${JOB_NAME}/workspace
if [ ! -d $commonJenkinsHOME ] ; then
	echo "RPM scribes home ,$commonJenkinsHOME, does not exist."
	exit 1;
fi
. $commonJenkinsHOME/lib/deployLib.sh
 
if [ ! -f $targetPath ] ; then
	echo "Cannot find $targetPath, please check it." 
fi

echo ">>>Try to Clean enviroment"
rpmName=Eagle.ramp.api

rpmSource=/tmp/$rpmName

if [ -d "$rpmSource" ] ; then
	rm -rf $rpmSource
	echo ">>>>>>Remove $rpmSource"
fi
mkdir -p $rpmSource

rsync -r --exclude=.svn $targetPath $rpmSource/
echo ">>>>>>Clean complete"

# Before clean
rm -rf *.rpm

_rpmBuild $rpmSource $rpmName $release $version $commonJenkinsHOME/RAMP_Build/rpm/rpmgen.cent63 $commonJenkinsHOME/RAMP_Build/rpm/dependency.list.Eagle.ramp.api $commonJenkinsHOME

_uploadRpm

