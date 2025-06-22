#/bin/bash

REPO_URL="https://github.com/Ravikharel/DevOps-Ravikharel.git"
TARGET_DIR="deploy"
TEST_SCRIPT="./test.sh"

echo "======================================="
echo " " 
echo " 	       Simple CI/CD Pipeline         "
echo " " 
echo "                   $(date)             " 
echo "======================================="


if [ -d "$TARGET_DIR/.git" ]; then
	echo "Pulling the latest change...."
	git -C "$Target_DIR" pull

else 
	echo "Cloning the Repository" 
	git clone "REPO_URL" "$TARGET_DIR"

fi

echo "Running the test" 
if $TEST_SCRIPT; then
	echo "Test passed, Deploying the production environment" 

else 
	echo "Test failed!!!, Aborting the deployment"
	exit 1
fi


echo " Copying the files to the production folder" 
cp -r "$TARGET_DIR"/ /var/www/html/

echo "Deployment successful" 

