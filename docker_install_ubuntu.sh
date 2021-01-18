#!/bin/bash

update() {
	sudo apt-get update -y
}

install_pre() {
	sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
}

curl_docker(){
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add
}

add_apt_respository(){
	sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
}

install_docker(){
	sudo apt-get install -y docker-ce
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

printf "Installing required apt...\n"
install_pre
step_done

printf "Curling docker installation path...\n"
curl_docker
step_done

printf "Adding repository...\n"
add_apt_respository
step_done

printf "Installing docker...\n"
install_docker
step_done

sudo systemctl enable docker

printf "Finished\n"
