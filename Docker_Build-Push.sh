#!/bin/bash
###############################################################################################
### This is a Bash script for Tag Build and Push your own container to your Repo in         ###
###                                                                                         ###
###         PLZ make sure you have an ID account on DockerHub.io                            ###
###         you have an explain in all function are what they do                            ###
###                         Example command to run:                                         ###
###  bash Docker_Build-Push.sh -u <Your-username> -p <Your-password> -c <Contaqiner-name>   ###
###                                                                                         ###
###############################################################################################

### display_usege function are help you to understand the script paranmeters
function display_usage() {
        cat <<EOF
Usage: $0
         [--dockerhub_username|-u]
         [--dockerhub_password|-p]
         [--container_name|-c]
         [--container_tag|-t]
         [--dockerhub_file_location|-d]
Arguments:
    --dockerhub_username        User name for DockerHub.io
    --dockerhub_password        Password for DockerHub.io
    --container_name            The container name
    --container_tag             The container TAG (You can leave blank | tag=latest ;
                                OR you can bump +1 your TAG Version
                                -t 1 = MAJOR (GET the last version and bump by 1 the MAJOR)
                                -t 2 = MINOR (GET the last version and bump by 1 the MINOR)
                                -t 3 = PATH  (GET the last version and bump by 1 the PATH) )
    --dockerhub_file_location   The DockerFile location folder (You can leave blank | script will choose your current folder)
EOF
        exit 1
}

### handle_parameters function ask you to enter your variables (username, password, container name, etc)
function handle_parameters() {

dockerhub_username=""
dockerhub_password=""
docker_file_location=""
container_name=""
container_tag=""


    until [ -z $1 ]; do
      case $1 in
          --dockerhub_username|-u )
              shift
              dockerhub_username="$1"
              ;;
          --dockerhub_password|-p )
              shift
              dockerhub_password="$1"
              ;;
          --container_name|-c )
              shift
              container_name="$1"
              ;;
          --container_tag|-t )
              shift
              container_tag="$1"
              ;;
          --docker_file_location|-d )
              shift
              docker_file_location="$1"
              ;;
          *)
              display_usage
              ;;

        esac
      shift
    done
    if  [ "$dockerhub_username" == "" ]; then
         echo "$dockerhub_username"
         echo "username is missing"
         display_usage
    fi

    if  [ "$dockerhub_password" == "" ]; then
        echo "Password is missing"
        display_usage
    fi

    if  [ "$docker_file_location" == "" ]; then
        docker_file_location=$(pwd)
    fi

    if  [ "$container_name" == "" ]; then
        echo "container name is missing"
        display_usage
    fi

    if  [ "$container_tag" == "" ]; then
        container_tag="latest"

    fi


}

### login to dockerhub.io whit official login command
function docker_login() {
  set +o history
  if echo "${dockerhub_password}" | docker login --username  "${dockerhub_username}" --password-stdin ; then
        :
  else
        exit
  fi
  set -o history
}
# Get latest docker image version
function check_ver() {

  TOKEN=$(curl -s -H "Content-Type: application/json" -X POST -d '{"username": "'${dockerhub_username}'", "password": "'${dockerhub_password}'"}' https://hub.docker.com/v2/users/login/ | jq -r .token)
  current_version=$(curl -s -H "Authorization: JWT ${TOKEN}" https://hub.docker.com/v2/repositories/${dockerhub_username}/${container_name}/tags/?page_size=10 | jq -rc '.results | sort_by(.last_updated) | map(select(.name as $in | ["latest"] | index($in) | not)) | .[-1].name')

  echo "Current version - ${current_version}"
  if [ ${current_version} == "null" ]; then
      current_version="0.0.0"
  fi

  }

function bump() {
major=$(echo $current_version | cut -f1 -d'.')
minor=$(echo $current_version | cut -f2 -d'.')
patch=$(echo $current_version | cut -f3 -d'.')

  if [ ${container_tag} == "1" ];then
      major=$(($major+1))
      container_tag="$major"".""$minor"".""$patch"

  elif [ ${container_tag} == "2" ];then
      minor=$(($minor+1))
      container_tag="$major"".""$minor"".""$patch"

  elif [ ${container_tag} == "3" ];then
      patch=$(($patch+1))
      container_tag="$major"".""$minor"".""$patch"
  fi
}

### build the container and push it to your repo account and return whit your REPO pull address
function build_push() {
  docker build -t "$container_name:$container_tag" "$docker_file_location"
  docker tag "$container_name:$container_tag" "$dockerhub_username/$container_name:$container_tag"
  docker push "$dockerhub_username/$container_name:$container_tag"
  echo "Container REPO to pull: "$dockerhub_username/$container_name:$container_tag"  "
}

### Delete the container you make log-out form docker for not save your certificates
function logout() {
  docker image rm "$container_name:$container_tag"
  docker logout
}

handle_parameters "$@"
check_ver
bump
docker_login
build_push
logout
