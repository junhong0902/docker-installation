#!/bin/bash

update() {
	yum update -y
}

install_pre() {
	yum install -y http://mirror.centos.org/centos/7/extras/x86_64/Packages/container-selinux-2.107-3.el7.noarch.rpm
}

add_docker_repo(){
	yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
}


install_docker(){
	yum install docker-ce -y
}

step() {
	local step_name=${1}

	printf "$step_name...\n"
}

step_done() {
	printf "DONE\n\n"
}

error() {
        local error_message=${1}

        if [[ ! -z $error_message ]]; then
            echo "Error: $error_message"
				
        fi

        exit 1
}


# installation steps
printf "Updating...\n"
update
step_done

printf "Updating...\n"
install_pre
step_done


printf "Curling docker installation path...\n"
add_docker_repo
step_done

printf "Installing docker...\n"
install_docker
step_done

systemctl start docker
sudo systemctl enable docker
curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
printf "Finished\n"
