#!/usr/bin/env bash

######  STRICT MODE  ###########################################

set -u
set -e
trap 'echo "Aborting due to errexit on line $LINENO. Exit code: $?" >&2' ERR
set -o errtrace
set -o pipefail
IFS=$'\n\t'

######  VARIABLES    ###########################################

_ME="$(basename "${0}")"          ##  This script
_instanceIndex=0                  ##  Possible that we'd want to select another instance
_reservationIndex=0               ##  Or a specific reservation...

export AWS_DEFAULT_OUTPUT="text"  ##  Makes parsing output easier

######  FUNCTIONS    ###########################################

_print_help() {
  cat <<HEREDOC

Simplify some basic AWS stuff such as connecting, start, stop, simple info etc.,
Assumes aws-cli is installed, and ssh connection is using a local private key 

Usage:
  ${_ME} [<arguments>]

Options:
  -h | --help     Show this screen.
  -u | --start    start the instance
  -c | --connect  start the instance & connect to it via ssh
  -d | --stop     stop the instance
  -i | --info     print info about the instance (status, tags etc)

HEREDOC
}

_has_awscli() {
  if ! command -v aws &> /dev/null
  then
    printf "aws shell not found\ntry apt install awscli\n"
    exit
  fi
}

_get_count_instances() {
  _res_count=$(_get_count_reservations); _ins_count=0
    for ((reservation=0; reservation < _res_count; reservation++)); do
      _res_ins_count=$(aws ec2 describe-instances --query "length(Reservations[$reservation].Instances)")
      _ins_count=$((_ins_count+_res_ins_count))
      done
  printf "%s$_ins_count\n"
}

_get_count_reservations() {
  printf "%s$(aws ec2 describe-instances --query "length(Reservations)")"
}

_is_script_suitable() {
  # if user has more than one reservation or instance, then probably not...
  _instance_count=$(_get_count_instances)
  _reservation_count=$(_get_count_reservations)
  if [[ $_reservation_count -gt 1 ]] || [[ $_instance_count -gt 1 ]]; then
    printf "This script will probably not work for you..."
    exit 1
  fi
    printf "%sinstances\t=$_instance_count\n"
    printf "%sreservations\t=$_reservation_count\n"
}

_get_instance_id() {
  aws ec2 describe-instances --query "Reservations[$_reservationIndex].Instances[$_instanceIndex].InstanceId"
}

_get_public_address() {
  ## The instance needs starting before we can get its' public Address...
  aws ec2 describe-instances --query "Reservations[$_reservationIndex].Instances[$_instanceIndex].PublicDnsName"
}

_is_instance_stopped() {
  aws ec2 describe-instances --query "Reservations[0].Instances[0].State.Name"

}

_start_instance() {
  if [[ $(_is_instance_stopped) == "stopped" ]]; then
    _instanceID=$(_get_instance_id)
    printf "%sStarting instance: $_instanceID\n"
    aws ec2 start-instances --instance-ids "$_instanceID"
  else 
    printf "%sInstance Status = $(_is_instance_stopped) exiting...\n"
    exit 1
    fi
  }

_stop_instance() {
    if [[ $(_is_instance_stopped) == "stopped" ]]; then
    printf "Already stopped - nothing to do...\n"
    else 
        _instanceID=$(_get_instance_id)
        printf "%sStopping instance: $_instanceID\n"
        aws ec2 stop-instances --instance-ids "$_instanceID"
    exit
    fi
}

_terminate_instances() {
  _instanceID=$(_get_instance_id)
  aws ec2 terminate-instances --instance-ids "$_instanceID"
}

_print_info() {
  # TODO:
  ## print useful info whilst we're waiting for the instance to boot...
  printf "not implemented!"
  true
}

_has_single_pk() {
  _single=true
  _count_pem=$(find . -type f -iname '*.pem' | wc -l)
  if [[ $_count_pem -ne 1 ]]; then _single=false; fi
  printf "%s$_single"

}

_ssh_to_instance() {
  if [[ $(_has_single_pk) == true ]]; then
    _address=$(_get_public_address)
    _key="*.pem"
    echo ssh -i $_key ubuntu@"$_address"
    ssh -i $_key ubuntu@"$_address"  
  else
    printf "This script needs a single .pem key...  Exiting\n"
    exit 1
  fi
}

###### OPTION PARSING ##########################################  

OPTIONS=hucdi
LONGOPTS=help,start,connect,stop,info

! PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    # e.g. return value is 1
    #  then getopt has complained about wrong arguments to stdout
    exit 2
fi
# read getopt’s output this way to handle the quoting right:
eval set -- "$PARSED"

up=0 # start the instance
dwn=0 # stop the instance
ssh=0 # connect to the instance
nfo=0 # print info
hlp=0 # need help?

if [ "$1" == '--' ]; then
    ## no options passed = help message
    hlp=1
else
  while true; do
      case "$1" in
          -h|--help) 
              hlp=1
              shift
              ;;
          -u|--start)
              up=1
              shift
              ;;
          -c|--connect)
              ssh=1
              shift
              ;;
          -d|--stop)
              dwn=1
              shift
              ;;
          -i|--info)
              nfo=1
              shift
              ;;
          --)
              shift
              break
              ;;
          *)
              echo "unrecognised flag."
              hlp=1
              ;;
      esac
  done 
fi

main() {
  if [[ $hlp -eq 1 ]]; then
  # print help and nothing else...
  _print_help
  else
    if [[ $up -eq 1 ]]; then _start_instance;  exit; fi
    if [[ $dwn -eq 1 ]]; then _stop_instance; exit; fi
    if [[ $ssh -eq 1 ]]; then 
      if [[ $(_is_instance_stopped) == "stopped" ]]; then
        printf "Instance needs starting\n"
        _start_instance
        sleep 60 ## 60 seconds should be enough...
      fi
      _ssh_to_instance
    fi
    if [[ $nfo -eq 1 ]]; then _printInfo; fi
  fi
}

main
