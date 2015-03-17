#!/bin/bash
basedir=`dirname $0`


DEMO="JBoss EAP Docker demo"
AUTHORS="Thomas Qvarnstrom, Red Hat & Christina Lin, Red Hat"
SRC_DIR=$basedir/installs

EAP_INSTALL=jboss-eap-6.3.0.zip

SOFTWARE=($EAP_INSTALL)


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

if [[ -r $SRC_DIR/$EAP_INSTALL || -L $SRC_DIR/$EAP_INSTALL ]]; then
		echo $EAP_INSTALL are present...
		echo
elif [[ -r ~/software/$EAP_INSTALL || -L $SRC_DIR/$EAP_INSTALL ]]; then
		echo  - $DOWNLOAD found in shared directory copying it to local install...
		echo
		cp ~/software/$EAP_INSTALL $SRC_DIR

else
		echo You need to download $EAP_INSTALL from the Customer Support Portal 
		echo and place it in the $SRC_DIR directory or ~/software/ to proceed...
		echo
		exit 3
fi


# Build the project
pushd $basedir/projects/simpledemo > /dev/null
echo - building the simepldemo project
mvn clean package > /dev/null
popd > /dev/null

echo - Building Docker images
echo 

cp -f $basedir/projects/simpledemo/target/simpledemo.war $basedir/images/eap/
cp -f $SRC_DIR/$EAP_INSTALL $basedir/images/eap/

docker-compose build > docker-build.log 2>&1

if [ $? -ne 0 ]; then
	echo "There was an error building the EAP image, please check docker-build.log"
	echo
	exit 4
fi

rm $basedir/images/eap/simpledemo.war
rm $basedir/images/eap/$EAP_INSTALL

echo Done with installation, now to run type docker-compose up -d
echo 
echo scale the app by runnning docker-compose scale jbosseap=10, where 10 is the number of instances to create
echo









