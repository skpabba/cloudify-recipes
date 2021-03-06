#!/bin/bash -x

# args:
# $1 cluster Host 
# $2 cluster Port 
# $3 cluster admin (user name)
# $4 cluster (admin's) password


clusterHost="$1"

export clusterHost="`wget -q -O - http://169.254.169.254/latest/meta-data/public-hostname`"
echo "Using public ip address - ${clusterHost}"

clusterPort="$2"
clusterAdmin="$3"
clusterPassword="$4"


# args:
# $1 the error code of the last command (should be explicitly passed)
# $2 the message to print in case of an error
# 
# an error message is printed and the script exists with the provided error code
function error_exit {
	echo "$2 : error code: $1"
	exit ${1}
}

export PATH=$PATH:/usr/sbin:/sbin:/opt/couchbase/bin || error_exit $? "Failed on: export PATH=$PATH:/usr/sbin:/sbin:/opt/couchbase/bin"

cli="/opt/couchbase/bin/couchbase-cli"


echo "Rebalancing cluster..."	
${cli} rebalance -u $clusterAdmin -p $clusterPassword -c $clusterHost:$clusterPort -d

echo "End of $0"
