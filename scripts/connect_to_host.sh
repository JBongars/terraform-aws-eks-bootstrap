#! /bin/bash

bastian_key_path="$PWD/keys/etp_bastion_host_key.pem"
bastian_dns="etp-bastion-host-lb-866e724badecad06.elb.us-west-2.amazonaws.com"

jenkins_key_path="$PWD/keys/etp_jenkins_key.pem"
jenkins_dns="ip-10-0-10-204.us-west-2.compute.internal"

function connect_to_bastian(){
    chmod 400 $bastian_key_path

    ssh -i $bastian_key_path "ubuntu@${bastian_dns}"
}

function connect_to_jenkins(){
    chmod 400 $bastian_key_path
    chmod 400 $jenkins_key_path

    # ssh -i $jenkins_key_path -o ProxyCommand="ssh -i ${bastian_key_path} -W %h:%p ubuntu@${bastian_dns}" "ubuntu@${jenkins_dns}"
    ssh -i $jenkins_key_path \ 
        -o ProxyCommand="ssh -i ${bastian_key_path} -W %h:%p ubuntu@${bastian_dns}" \
        -o StrictHostKeyChecking=no "ubuntu@${jenkins_dns}"
}

function connect_to_jenkins_dashboard(){
    chmod 400 $bastian_key_path
    chmod 400 $jenkins_key_path

    ssh -i $jenkins_key_path -L 127.0.0.1:8080:localhost:8080 \
        -o ProxyCommand="ssh -i ${bastian_key_path} -W %h:%p ubuntu@${bastian_dns}" \
        -o StrictHostKeyChecking=no "ubuntu@${jenkins_dns}"
}



