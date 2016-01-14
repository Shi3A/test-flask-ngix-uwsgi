sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get install aptitude
sudo aptitude -y install build-essential
sudo aptitude install python3-pip
sudo aptitude -y install python3.4-dev
sudo aptitude -y install nginx
sudo aptitude install git


sudo pip3 install virtualenv

mkdir /var/www/flasktest
cd /var/www/flasktest
sudo virtualenv -p /usr/bin/python3 venv
sudo su root
source venv/bin/activate
pip install uwsgi
pip install flask


##########
Old
##########
I am doing all these commands as root
Download and install miniconda
$ conda create -n testenv python=3.5 flask virtualenv
$source actuvate testenv
I do this next line so that the normal conda source activate ... works
$ ~/miniconda3/envs/testenv/ /var/www/flasktest/testenv/


$ sudo apt-get install nginx uwsgi uwsgi-plugin-python3

inside /var/www
$ git clone https://github.com/vincentdavis/test-flask-ngix-uwsgi.git flasktest

################

sudo service uwsgi restart

sudo service nginx restart

tail /var/log/uwsgi/app/flasktest.log

tail /var/log/nginx/error.log