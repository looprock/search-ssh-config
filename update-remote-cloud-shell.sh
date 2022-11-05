#!/bin/bash
current_cloud_ip=`gcloud alpha cloud-shell ssh --dry-run |grep '/usr/bin/ssh' |awk -F"@" {'print $2'}|awk {'print $1'}`
sshconf_ip=`search-ssh-config $HDIR/.ssh/config google-cloud-shell | grep "HostName"|awk {'print $2'}`
echo "Current IP: $current_cloud_ip, SSH Config IP: $sshconf_ip"
if [ "$current_cloud_ip" != "$sshconf_ip" ]; then
    echo "Updating IP in ssh config"
    sed -i "s/$sshconf_ip/$current_cloud_ip/g" $HDIR/.ssh/config
else
    echo "IP is up to date"
fi