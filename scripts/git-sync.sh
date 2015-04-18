#!/bin/bash
if [[ `git symbolic-ref --short -q HEAD` != master ]] && [[ $1 != "force" ]]; then
	echo "Aborting sync since we're not on branch 'master'."
	exit 0
fi

# Grab our config
. scripts/config.sh

mkdir -p tmp/

csync () {
	echo "Sync: $1.$serversuffix"
	getconfig $1 > tmp/$1.conf
	scp ${options[$1]} tmp/$1.conf ${servers[$1]}:~/inspircd/etc/inspircd.conf
	rm tmp/$1.conf
}

for server in "${!servers[@]}"
do
   csync "$server"
done