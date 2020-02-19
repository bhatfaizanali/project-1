#Usage: ./directoryInitilize type username
#=========================================

#!/bin/bash

if [ -z $3 ];then
	echo 'Usage: ./directoryInitilize type username '
	exit;
fi

if [ "$1" = target ];then
mkdir -p ../database/$3/$2/subdomains
mkdir -p ../database/$3/$2/ipranges
mkdir -p ../database/$3/$2/scandata/sslscan
mkdir -p ../database/$3/$2/screenshots
fi


