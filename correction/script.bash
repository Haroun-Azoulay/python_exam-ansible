#!/bin/bash

GREEN='\e[32m'
YELLOW='\e[33m'
RED='\e[31m'
NC='\e[0m'

# Change with your VM
USER="haroun"
HOST="127.0.0.1"
PORT="2222"
PASSWORD="azerty"
FILE="dummy.txt"

connexion_ssh() {
    result=$(sshpass -p "$PASSWORD" ssh "$USER@$HOST" -p "$PORT" "$1")
    echo "$result"
}

func_command() {
    command="cd /tmp && find -name dummy-file"
    result=$(connexion_ssh "$command")

    if [[ -n "$result" ]]; then
        echo -e "${GREEN}SUCCESS: Find found: $result${NC}"
        connexion_ssh "cd /tmp && rm -f /tmp/dummy-file"
        echo -e "${YELLOW}INFO : The file is deleted.${NC}"
    else
        echo -e "${RED}ERROR : File not found.${NC}"
    fi
}

func_apt() {
    apt="apt list --installed | grep nginx"
    result=$(connexion_ssh "$apt")

    if [[ -n "$result" ]]; then
        echo -e "${GREEN}SUCCESS : Find found: $result.${NC}"
        connexion_ssh "echo $PASSWORD | sudo -S apt remove -y nginx"
        echo -e "${YELLOW}INFO: The package are deleted.${NC}"
    else
        echo -e "${RED}ERROR : Package not found.${NC}"
    fi
}

func_sysctl() {
    sysctl="sysctl net.core.somaxconn"
    result=$(connexion_ssh "echo $PASSWORD | sudo -S $sysctl")
    result=$(echo "$result" | tr -d '\r' | xargs)
    if [[ $result == "net.core.somaxconn = 8192" ]]; then
        echo -e "${GREEN}SUCCESS : Parameters about net.core.somaxconn are good.${NC}"
        connexion_ssh "echo $PASSWORD | sudo -S sysctl -w net.core.somaxconn=1024"
        echo -e "${YELLOW}INFO : The value about net.core.somaxonn are modified.${NC}"
    else
        echo -e "${RED}ERROR : Don't retrieve 8192 but : $result.${NC}"
    fi
}

func_service_nginx() {
    serviceNginx="systemctl is-active nginx.service"
    result=$(connexion_ssh $serviceNginx)
    if [[ "$result" == "active" ]]; then
        echo -e "${GREEN}SUCCESS: Nginx is active${NC}"
        connexion_ssh "echo $PASSWORD | sudo -S systemctl stop nginx.service"
        echo -e "${YELLOW}INFO : Nginx are stoped.${NC}"
    else
        echo -e "${RED}ERROR : Nginx is not active.${NC}"
    fi
}

func_service_docker() {
    result=$(connexion_ssh "systemctl is-active docker")
    if [[ "$result" == "active" ]]; then
        echo -e "${GREEN}SUCCESS: Docker is active.${NC}"
        connexion_ssh "echo $PASSWORD | sudo -S systemctl stop docker"
        echo -e "${YELLOW}INFO : Docker are stoped.${NC}"
    else
        echo -e "${RED}ERROR : Docker is not active${NC}"
    fi
}

func_copy() {
    result=$(connexion_ssh "find -name $FILE")
    if [[ -n "$result" ]]; then
        echo -e "${GREEN}SUCCESS: Files are found. Please check if the copy from guest to host was successful.${NC}"
        connexion_ssh "rm $FILE"
        echo -e "${YELLOW}INFO: The file are removed.${NC}"
    else
        echo -e "${RED}ERROR : Dont retrieve the file.${NC}"
    fi
}

func_template() {
    result=$(connexion_ssh "grep -q '8000' /etc/nginx/sites-enabled/default/default.conf.j2 && grep -q '_' /etc/nginx/sites-enabled/default/default.conf.j2 && echo 0 || echo 1")
    if [[ "$result" -eq 0 ]]; then
        echo -e "${GREEN}SUCCESS: The variables are found in default.conf.j2.${NC}"
        connexion_ssh "echo $PASSWORD | sudo -S rm /etc/nginx/sites-enabled/default/default.conf.j2"
        echo -e "${YELLOW}INFO: The file has been removed.${NC}"
    else
        echo -e "${RED}ERROR: Could not find file or required variables.${NC}"
    fi
}

figlet "Welcome to the Ansible correction"

options=("COMMAND" "APT" "SYSCTL" "SERVICE NGINX" "SERVICE DOCKER" "COPY" "TEMPLATE" "EXIT")

while true; do
    echo ""
    echo "===== MENU ====="
    for i in "${!options[@]}"; do
        printf "%d) %s\n" $((i + 1)) "${options[$i]}"
    done
    echo "================"

    read -p "Please enter your choice (or q to quit): " REPLY

    if [[ "$REPLY" =~ ^[qQ]$ ]]; then
        echo "Exiting..."
        break
    fi

    if [[ "$REPLY" =~ ^[0-9]+$ ]] && ((REPLY >= 1 && REPLY <= ${#options[@]})); then
        opt="${options[$((REPLY - 1))]}"
        case "$opt" in
        "COMMAND")
            func_command
            ;;
        "APT")
            func_apt
            ;;
        "SYSCTL")
            func_sysctl
            ;;
        "SERVICE NGINX")
            func_service_nginx
            ;;
        "SERVICE DOCKER")
            func_service_docker
            ;;
        "COPY")
            func_copy
            ;;
        "TEMPLATE")
            func_template
            ;;
        "EXIT")
            echo "Exiting..."
            break
            ;;
        esac
    else
        echo -e "${RED}Invalid option: $REPLY${NC}"
    fi
done
