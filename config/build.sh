sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get install aptitude
sudo aptitude -y install build-essential

####
# Download and install miniconda
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
Miniconda3-latest-Linux-x86_64.sh
# This is the virtual env to be used by the flask app
conda create -n testenv python=3.5 flask virtualenv uwsgi

###
# To be completed.
