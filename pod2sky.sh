#!/bin/bash
KUBE_MASTER="http://localhost:8080"
CLUSTER_DOMAIN="local.domain"
TEMP=`getopt -o a --long kube_master_url:,cluster_domain: -- "$@"`
eval set -- "$TEMP"
while true ; do
  case "$1" in
  --kube_master_url) KUBE_MASTER="$2";shift 2;;
  --cluster_domain) CLUSTER_DOMAIN="$2";shift 2;;
  --) shift ; break ;;
  *) echo "$1";exit 1;;
esac
done

function convert2path(){
  array=(${1//./ })
  path=""
  length=${#array[@]}
  for((i=$[$length-1];i>=0;i--))
  do
     path=${path}/${array[$i]}
  done
  echo $path

}

curl -s ${KUBE_MASTER}/api/v1/pods |jq -rc ".items[]|{hostname:.metadata.name,ip:.status.podIP}"  > /tmp/pods.txt
path=`convert2path $CLUSTER_DOMAIN`
cat /tmp/pods.txt |while read LINE
     do
       HOSTNAME=`echo $LINE|jq -r ".hostname"`
       IP=`echo $LINE|jq -r ".ip"`
       curl -XPUT -s http://127.0.0.1:4001/v2/keys/skydns$path/$HOSTNAME -d value={\"host\":\"$IP\"} 2>&1
       ipPath=${IP//.//}
       ipPath=/arpa/in-addr/$ipPath
       curl -XPUT -s http://127.0.0.1:4001/v2/keys/skydns$ipPath -d value={\"host\":\"$HOSTNAME\"} 2>&1
     done

