# Docker_Build-push_bash

<a href="https://ssh.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https%3A%2F%2Fgithub.com%2Famit-shochat%2FDocker_Build-push_bash">
<img alt="Open in Cloud Shell" src="https://gstatic.com/cloudssh/images/open-btn.svg"></a>


**This is a Bash script for Build and push your own container to your Repo in DockerHube. make sure you have an ID account on DockerHub.io**

Arguments you can use on the script OR -help/-h on CLI 
<pre> Arguments:
- dockerhub_username|-u          User name for DockerHub.io 
- dockerhub_password|-p	         Password for DockerHub.io
- container-name|-c              The container name
- container-tag|-t               The container TAG (You can leave blank | tag=latest)
- dockerhub_file_location|-d     The DockerFile location folder (You can leave blank | script will choose your current folder)
</pre>
   

Example command to run:                                         
<pre>
bash Docker_Build-Push.sh -u <Your-username> -p <Your-password> -c alpine
</pre>           
