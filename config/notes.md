I am doing all these commands as root
Download and install miniconda
$ conda create -n testenv python=3.5 flask virtualenv
$source actuvate testenv
I do this next line so that the normal conda source activate ... works
$ ~/miniconda3/envs/testenv/ /var/www/flasktest/testenv/


$ sudo apt-get install nginx uwsgi uwsgi-plugin-python

inside /var/www
$ git clone https://github.com/vincentdavis/test-flask-ngix-uwsgi.git flasktest

################
