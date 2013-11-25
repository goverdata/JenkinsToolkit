import ConfigParser  
import string, os, sys  

#if len(sys.argv) < 2:  
#   print u'Use as: key value\n'
#   sys.exit(0)
#key = sys.argv[1]
#value = sys.argv[2]

buildNum = os.getenv('BUILD_NUMBER') 
key = "RPM_NAME"
value = "RAMP_NAME_VALUE-" + buildNum + "-centos6.3_64.rpm"
print "key = " + key
print "value = " + value 

# Check the properties file
confPath = '/tmp/jenkins_johnny.properties'
confExist = os.path.exists(confPath)
if cmp(confExist, "True") != 0 :
  open(confPath,'w')

# Parse the file
confParser = ConfigParser.ConfigParser()  
confParser.read(confPath)  
  
# Check GlobalVariables section
allSections = confParser.sections()
if "GlobalVariables" in allSections :
  gvExist = True
else:
  gvExist = False

if gvExist is False :
  confParser.add_section("GlobalVariables")

confParser.set("GlobalVariables",key,value)
confParser.write(open(confPath,"w"))
