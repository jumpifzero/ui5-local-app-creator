#!/bin/bash
#
# This script will create a folder with that name under your projects folder.
# It will then clone a git repo into it and enable an apache website serving those files.
# The website will be available under a url something.app.com (which points to localhost)
#

SCRIPT_FOLDER=`dirname "$BASH_SOURCE"`
PROJECTS_FOLDER=~/projectos/
UI5_RESOURCES_FOLDER=/home/tiago/lib/ui5/sapui5-1.40.12/resources


cd $PROJECTS_FOLDER

echo Please enter the name of the application. Must be unique and cannot contain spaces.
echo This script will create a folder with that name under your projects folder.
echo It will then clone a git repo into it and enable an apache website serving those files.
read -p 'App name: ' app_name

# Copy the apache .conf template file into the apache sites available folder.
sed -e "s/%USER%/${USER}/g;s/%APP_NAME%/${app_name}/g" \
    ${SCRIPT_FOLDER}/ui5-create-files/site-available-template.conf > ${app_name}.app.com.conf
sudo mv ${app_name}.app.com.conf /etc/apache2/sites-available/

echo Please enter the url for the git repository holding the application.
read -p 'git repository: ' git_repo_url
git clone $git_repo_url ${app_name}


# Create a link between the www folder and the webapp inside the git created folder
cd /var/www/${app_name}
ln -s -T ${PROJECTS_FOLDER}/${app_name}/webapp html
# create a /resources pointing to ui5
ln -s -T ${UI5_RESOURCES_FOLDER} resources

# Enable the website
sudo a2ensite ${app_name}.app.com.conf
sudo service apache2 reload

# Create an entry on /etc/hosts
echo Create an entry on /etc/hosts pointing to 127.0.0.1 with ${app_name}.app

