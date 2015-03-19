#!/bin/bash
basedir=`dirname $0`


DEMO="JBoss EAP Docker demo"
AUTHORS="Thomas Qvarnstrom, Red Hat"
SRC_DIR=$basedir/installs

EAP_INSTALL=jboss-eap-6.3.0.zip
EAP_PATCH=jboss-eap-6.3.3-patch.zip

SOFTWARE=($EAP_INSTALL $EAP_PATCH)


# wipe screen.
clear 

echo

ASCII_WIDTH=52

printf "##  %-${ASCII_WIDTH}s  ##\n" | sed -e 's/ /#/g'
printf "##  %-${ASCII_WIDTH}s  ##\n"   
printf "##  %-${ASCII_WIDTH}s  ##\n" "Setting up the ${DEMO}"
printf "##  %-${ASCII_WIDTH}s  ##\n"
printf "##  %-${ASCII_WIDTH}s  ##\n"
printf "##  %-${ASCII_WIDTH}s  ##\n" "    # ####   ###   ###  ###   ####    ##    ####"
printf "##  %-${ASCII_WIDTH}s  ##\n" "    # #   # #   # #    #      #      #  #   #   #"
printf "##  %-${ASCII_WIDTH}s  ##\n" "    # ####  #   #  ##   ##    ##    ######  ####"
printf "##  %-${ASCII_WIDTH}s  ##\n" "#   # #   # #   #    #    #   #    #      # #"
printf "##  %-${ASCII_WIDTH}s  ##\n" " ###  ####   ###  ###  ###    #### #      # #"  
printf "##  %-${ASCII_WIDTH}s  ##\n"
printf "##  %-${ASCII_WIDTH}s  ##\n"
printf "##  %-${ASCII_WIDTH}s  ##\n"   
printf "##  %-${ASCII_WIDTH}s  ##\n" "brought to you by,"
printf "##  %-${ASCII_WIDTH}s  ##\n" "${AUTHORS}"
printf "##  %-${ASCII_WIDTH}s  ##\n"
printf "##  %-${ASCII_WIDTH}s  ##\n"
printf "##  %-${ASCII_WIDTH}s  ##\n" | sed -e 's/ /#/g'

echo
echo "Setting up the ${DEMO} environment..."
echo



# Check that maven and docker-compose is installed and on the path
mvn -v -q >/dev/null 2>&1 || { echo >&2 "Maven is required but not installed yet... aborting."; exit 1; }
docker-compose --version >/dev/null 2>&1 || { echo >&2 "docker-compose is required, please install it"; exit 2; }

# Create install dir if not existing
if [[ ! -d $SRC_DIR ]]; then
	echo  - Creating install dir to hold binaries
	echo
	mkdir -p $SRC_DIR
fi

# Verify that necesary files are downloaded
for DONWLOAD in ${DOWNLOADS[@]}
do
	if [[ -r $SRC_DIR/$DONWLOAD || -L $SRC_DIR/$DONWLOAD ]]; then
		echo $DONWLOAD are present...
		echo
	elif [[ -r ~/software/$DONWLOAD || -L $SRC_DIR/$DONWLOAD ]]; then
		echo  - $DOWNLOAD found in shared directory copying it to local install...
		echo
		cp ~/software/$DONWLOAD $SRC_DIR
	else
		echo You need to download $DONWLOAD from the Customer Support Portal 
		echo and place it in the $SRC_DIR directory or ~/software/ to proceed...
		echo
		exit 3
	fi
done


# Build the project
pushd $basedir/projects/simpledemo > /dev/null
echo - building the simpledemo project
mvn clean package > /dev/null
popd > /dev/null

echo - building Docker images
echo 

cp -f $basedir/projects/simpledemo/target/simpledemo.war $basedir/images/eap/
cp -f $SRC_DIR/$EAP_INSTALL $basedir/images/eap/
cp -f $SRC_DIR/$EAP_PATCH $basedir/images/eap/

docker-compose -p demo -f docker-compose-build.yml build base > docker-build-base.log 2>&1
if [ $? -ne 0 ]; then
	echo "There was an error building the EAP image, please check docker-build-base.log"
	echo
	exit 4
fi

docker-compose -p demo -f docker-compose-build.yml build basejdk > docker-build-basejdk.log 2>&1
if [ $? -ne 0 ]; then
	echo "There was an error building the EAP image, please check docker-build-basejdk.log"
	echo
	exit 4
fi

docker-compose -p demo -f docker-compose-build.yml build jbosseap > docker-build-jbosseap.log 2>&1
if [ $? -ne 0 ]; then
	echo "There was an error building the EAP image, please check docker-build-jbosseap.log"
	echo
	exit 4
fi


rm $basedir/images/eap/simpledemo.war
rm $basedir/images/eap/$EAP_INSTALL
rm $basedir/images/eap/$EAP_PATCH

echo Done with installation, now to run type docker-compose -p demo up -d
echo 
echo scale the app by runnning docker-compose scale jbosseap=10, where 10 is the number of instances to create
echo









