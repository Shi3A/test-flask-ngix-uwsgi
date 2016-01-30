#!/bin/bash

# Tested on Ubuntu 15.10 desktop amd64 with systemd

# defaults
packages="aptitude nginx uwsgi uwsgi-plugin-python3"

pushd `dirname $0` > /dev/null
scrpit_current_dir=`pwd -P`
popd > /dev/null

HOME_DIR=$(dirname "$scrpit_current_dir")
NGNX_ETC_DIR="/etc/nginx"
NGNX_VIRTUALHOST_PATH="${NGNX_ETC_DIR}/sites-enabled/flask_uwsgi.conf"
NGNX_SERVER_NAME="test" # change me
UWSGI_ETC_DIR="/etc/uwsgi"
UWSGI_LISTEN="127.0.0.1:8000"
UWSGI_MODULE="testapp"
UWSGI_CALLABLE="app"
UWSGI_VIRTUALHOST_PATH="${UWSGI_ETC_DIR}/apps-enabled/${NGNX_SERVER_NAME}.ini"
SYSTEMD_ETC_DIR="/etc/systemd/system"

ENV_NAME="testenv"
ENV_PATH="$HOME/miniconda3/envs/${ENV_NAME}"

install_requirements(){
	sudo apt-get update
	sudo apt-get -y upgrade
	sudo apt-get -y install ${packages}
	sudo aptitude -y install build-essential
}

feel_nginx_temaplate(){
	sudo cp -f $scrpit_current_dir/nginx_template ${NGNX_ETC_DIR}/sites-available/flask_uwsgi.conf
	sudo ln -sf ../sites-available/flask_uwsgi.conf ${NGNX_VIRTUALHOST_PATH}
	sudo sed -i "s|%SERVER_NAME%|${NGNX_SERVER_NAME}|g" ${NGNX_VIRTUALHOST_PATH}
	sudo sed -i "s|%ROOT_PATH%|${HOME_DIR}|g" ${NGNX_VIRTUALHOST_PATH}
	sudo sed -i "s|%UWSGI_LISTEN%|${UWSGI_LISTEN}|g" ${NGNX_VIRTUALHOST_PATH}
}

feel_uwsgi_template(){
	sudo cp -f $scrpit_current_dir/uwsgi_template ${UWSGI_ETC_DIR}/apps-available/${NGNX_SERVER_NAME}.ini
	sudo ln -fs ../apps-available/${NGNX_SERVER_NAME}.ini ${UWSGI_VIRTUALHOST_PATH}
	sudo sed -i "s|RUN_AT_STARTUP=yes|RUN_AT_STARTUP=no|g" /etc/default/uwsgi
	sudo sed -i "s|%UWSGI_LISTEN%|${UWSGI_LISTEN}|g" ${UWSGI_VIRTUALHOST_PATH}
	sudo sed -i "s|%SERVER_NAME%|${NGNX_SERVER_NAME}|g" ${UWSGI_VIRTUALHOST_PATH}
	sudo sed -i "s|%ENV_PATH%|${ENV_PATH}|g" ${UWSGI_VIRTUALHOST_PATH}
	sudo sed -i "s|%HOME_DIR%|${HOME_DIR}|g" ${UWSGI_VIRTUALHOST_PATH}
	sudo sed -i "s|%UWSGI_MODULE%|${UWSGI_MODULE}|g" ${UWSGI_VIRTUALHOST_PATH}
	sudo sed -i "s|%UWSGI_CALLABLE%|${UWSGI_CALLABLE}|g" ${UWSGI_VIRTUALHOST_PATH}
}

deploy_emperor() {
	sudo cp -f $scrpit_current_dir/emperor_template ${SYSTEMD_ETC_DIR}/emperor.uwsgi.service
	sudo sed -i "s|%APP_INI_PATH%|${UWSGI_VIRTUALHOST_PATH}|g" ${SYSTEMD_ETC_DIR}/emperor.uwsgi.service
}

install_requirements
feel_nginx_temaplate
feel_uwsgi_template
deploy_emperor
####
# Download and install miniconda
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ${scrpit_current_dir}/Miniconda3-latest-Linux-x86_64.sh
bash ${scrpit_current_dir}/Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda3
export PATH=$HOME/miniconda3/bin:$PATH
conda install -y anaconda-client
# This is the virtual env to be used by the flask app
conda create -n ${ENV_NAME} -y python=3.5 flask virtualenv

sudo systemctl disable uwsgi.service > /dev/null 2>&1
sudo systemctl restart nginx.service > /dev/null 2>&1
sudo systemctl enable emperor.uwsgi.service > /dev/null 2>&1
sudo systemctl restart emperor.uwsgi.service > /dev/null 2>&1

echo "All done"
