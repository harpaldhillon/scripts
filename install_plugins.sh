#!/bin/bash

# Script to download jenkins plugins and al its dependencies
# Also syncronize with jenkins plugins directory 
# Added by: Harpal Dhillon
# Date: 2017-02-09

set -e

JENKINS_SERVER_PATH="http://updates.jenkins-ci.org/download/plugins/"

file_owner=jenkins.jenkins

#read plugins to download from plugins.txt
plugins_file="plugins.txt"     #full path of plugins.txt file
plugin_dir="/var/lib/jenkins/plugins"     #jenkins plugin directory
down_dir=`pwd`          #temporary directory to download plugins

mkdir -p $plugin_dir $down_dir

#function to download functions from jenkins server 
installPlugins()
{
  name=$1
  version=$2

  if [ -f $name.hpi ]
  then 
    echo "Plugin $name already present in download directory"
    return 0
  fi

  wget $JENKINS_SERVER_PATH/$name/$version/$name.hpi -P $down_dir
  return 0
}

# If plugins.txt file exists
if [ -f "$plugins_file" ]
then
        while IFS=':' read -r name version
        do
            installPlugins $name $version
        done < "$plugins_file"
fi

echo "Now we will download missing dependencies, if any"

for plugin in $down_dir/*.hpi; do
       deps=$( unzip -p ${plugin} META-INF/MANIFEST.MF | tr -d '\r' | sed -e ':a;N;$!ba;s/\n //g' | grep -e "^Plugin-Dependencies: " | awk '{ print $2 }' | tr ',' '\n'  | grep -v "resolution:=optional" | tr '\n' ' ' | tr ';' ' ')

       echo "Dependencies list:   " $deps

       for d in $deps
       do 
          plugin=$( echo $d|awk -F ' ' '{print $1}' )
          plugin_name=$( echo $plugin|awk -F ':' '{print $1}' )
          plugin_version=$( echo $plugin|awk -F ':' '{print $2}' )

          installPlugins $plugin_name $plugin_version
       done
done


echo "Now sync local download directory with jenkins plugin directory"

rsync -r $down_dir/*.hpi $plugin_dir

echo "update permissions"
chown ${file_owner} ${plugin_dir} -R

echo "job done"
