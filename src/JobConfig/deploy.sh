#!/bin/bash

release=$1
version=$2
rpmName=[RPM-NAME]-$release
packageName=[RPM_NAME]

expectRPM=`rpm -qa | grep expect`
if [ -z $expectRPM ] ; then
	wget -O /tmp/expect-5.43.0-8.el5.i386.rpm ftp://rpmfind.net/linux/centos/5.9/os/x86_64/CentOS/expect-5.43.0-8.el5.i386.rpm
	wget -O /tmp/tcl-8.4.13-6.el5.i386.rpm ftp://rpmfind.net/linux/centos/5.9/os/x86_64/CentOS/tcl-8.4.13-6.el5.i386.rpm
	rpm -ivh /tmp/tcl-8.4.13-6.el5.i386.rpm
	rpm -ivh /tmp/expect-5.43.0-8.el5.i386.rpm
fi

tomcatRPM=`rpm -qa | grep tomcat`
if [ -z $tomcatRPM ] ; then
	expect -c "set timeout 5000
       spawn yum install [TOMCAT_RPM]
       expect {
               "*y/N*" { send "yes\\r"; exp_continue }
       }
	"
else
	sudo /etc/init.d/tomcat.sh stop
	rm -rf /usr/local/apache-tomcat_1/shared
	rm -rf /usr/local/apache-tomcat_1/bin/setenv.sh
fi

sleep 5
jdkName=[JDK_RPM]
force=`echo $force | tr 'a-z' 'A-Z'`
if [ "$force" == "TRUE" ] ; then
	rpm -e $rpmName
	yum -y remove $rpmName	
fi
yum clean all

jdkintall=`rpm -qa|grep jdkName`
if [ -z $jdkintall ]; then
   expect -c "set timeout 5000
      spawn yum install $rpmjdkName
       expect {
                "*y/N*" { send "yes\\r"; exp_continue }
       }
      "
fi

expect -c "set timeout 10000
      spawn yum install $rpmName
       expect {
                "*y/N*" { send "yes\\r"; exp_continue }
       }
      "
sleep 10

puppet agent --test
sleep 10

sudo /etc/init.d/tomcat.sh start

# Build the war package
cd /opt/apache-tomcat_1/webapps/rampapi/
jar -cvf ../rampapi.war *
chown nobody:nobody ../rampapi.war
chmod 755 ../rampapi.war
