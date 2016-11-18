#!/bin/bash

environments=(dev prod)

if [ ! -f docker.priv.env ]
then
  echo "docker.priv.env file missing. Please create one"
  exit 1
fi

eval $(cat docker.priv.env)
if [ $SUDO == true ]
then
    cmdenv="eval $(cat docker.priv.env) sudo -E"
else
    cmdenv="eval $(cat docker.priv.env) "
fi
cmdprefix="$cmdenv docker-compose -f ./docker-compose.yml -f docker-compose.$ENV.yml"

if [[ -z $ENV || ! ${environments[*]} =~ $ENV ]]
then
  echo "ENV variable not set or has unacceptable value."
  exit 1
fi

################ ARGUMENTS ###########
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    up|build|stop|bash)
	ACTION=$key
	shift # past argument
	;;
    *)
        if [ ! -z $2 ]
        then
            echo "Error : unknown argument"
	    echo "Usage:      ./compose.sh [OPTION] [SUBOPTION]  service"
            echo "* options:"
	    echo "    up        Runs a service as a daemon (the -d is automatically added)"
	    echo "    build     pull base image & build from dockerfile"
	    echo "    stop      Stops specified service"
	    echo "    bash      Opens a bash shell inside a running container"
	    exit 1
        fi
	echo "service to manage : $1"
	service=$1
	shift

	;;
esac
done


case "$ACTION" in
    # Parse options to the install sub command
    build)
	command="$cmdprefix build --pull $service"
	;;
    up)
	command="$cmdprefix up -d $service"
	;;

    stop)
	command="$cmdprefix stop $service"
	;;

    bash)
	command="$cmdprefix exec $service /bin/bash"
	;;
esac

echo $command
$command
