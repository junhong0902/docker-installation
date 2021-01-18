#!/bin/bash

update() {
	yum update -y
}

install_pre() {
	yum install epel-release dnf -y
}

list_docker(){
	dnf list docker-ce
}

add_apt_respository(){
	dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
}

install_docker(){
	dnf install docker-ce --nobest -y
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
printf "Apt-get update...\n"
update
step_done

printf "Adding repository...\n"
add_apt_respository
step_done

printf "Curling docker installation path...\n"
list_docker
step_done

printf "Installing docker...\n"
install_docker
step_done

systemctl start docker
sudo systemctl enable docker
dnf install curl -y
curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
printf "Finished\n"
