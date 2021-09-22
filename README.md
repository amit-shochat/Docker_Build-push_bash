# Docker_Build-push_bash

<a href="https://ssh.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https%3A%2F%2Fgithub.com%2Famit-shochat%2FDocker_Build-push_bash">
<img alt="Open in Cloud Shell" src="https://gstatic.com/cloudssh/images/open-btn.svg"></a>


**This is a Bash script for Build and push your own container to your Repo in DockerHube. make sure you have an ID account on DockerHub.io**

Arguments you can use on the script OR -help/-h on CLI 
<pre> Arguments:
    --dockerhub_username        User name for DockerHub.io
    --dockerhub_password        Password for DockerHub.io
    --container_name            The container name
    --container_tag             The container TAG (You can leave blank | tag=latest ;
                                OR you can bump +1 your TAG Version
                                -t 1 = MAJOR (GET the last version and bump by 1 the MAJOR)
                                -t 2 = MINOR (GET the last version and bump by 1 the MINOR)
                                -t 3 = PATH  (GET the last version and bump by 1 the PATH) )
    --dockerhub_file_location   The DockerFile location folder (You can leave blank | script will choose your current folder)
</pre>
   

Example command to run:                                         
>bash Docker_Build-Push.sh -u <Your-username\> -p <Your-password\> -c <Contaqiner-name| exmaple=alpine-test\> -t 3
       
