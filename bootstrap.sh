#!/bin/bash

set -e
set -o pipefail

unset action
unset filepath
unset id
unset url

tfdirs="networking appinfra"
bucket="buildatscale-terraform-state-files"

Help(){
   # Display Help
   echo "This script builds out the entire Project, by running all needed Terraform deployments. "
   echo
   echo "Syntax: ./bootstrap.sh [-a|h]"
   echo "options:"
   echo "a     Create or destroy the Project. *NOTE* Choices are (create|destroy)"
   echo "h     Print this Help."
   echo
}

exit_with_help()
{
  Help
  exit 1
}

reverse(){
  tr ' ' '\n'<<<"$@"|tac|tr '\n' ' ';
}

create(){
  aws s3api create-bucket --bucket $bucket
  for tfdir in $tfdirs
  do
      echo "Creating Terraform Infrastructure in $tfdir"
      pushd $tfdir && ./tf.sh init dev && ./tf.sh apply dev && popd && sleep 5
      echo "Sleeping..."
  done || exit 1
}

destroy(){
  for tfdir in $(reverse $tfdirs)
  do
      echo "Destroying Terraform Infrastructure in $tfdir"
      pushd $tfdir && ./tf.sh init dev  && ./tf.sh destroy dev && popd && sleep 5
      echo "Sleeping..."

  done || exit 1
#  aws s3 rm s3://$bucket --recursive
#  aws s3 rb s3://$bucket
}

main(){

  ### Argparse ###
  while getopts ":a:h" option; do
     case $option in
        a)
          action=${OPTARG}
          ;;
        h) # display Help
           Help
           exit;;
       \?) # incorrect option
           echo "Error: Invalid option" >&2
           exit_with_help
           ;;
     esac
  done

#  ### Validation ###
  if [ $OPTIND -eq 1 ]; then echo "No options were passed!" >&2 && exit_with_help; fi

  if [ $action == "create" ]; then
    create

  elif [ $action == "destroy" ]; then
    destroy

    echo "Resources Destroyed!"

  else
    echo "Option -a should be either create or destroy"
    exit_with_help
  fi
}

main "$@"