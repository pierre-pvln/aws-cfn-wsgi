#!/usr/bin/env bash

# ---------------------------- INSTALL NOTES ----------------------------
# To properly setup the AWS CLI, make sure that this shell script is run with the two required positional args:
#   $1 :: (string) AWS Access Key ID
#   $2 :: (string) AWS Secret Key
#
# Also make sure to give the script permission to run!:
#    chmod 755 /home/ubuntu/install.sh
#
# -----------------------------------------------------------------------


# ++++++++++++++++++++ START ANACONDA INSTALL +++++++++++++++++++++
#sudo su

# Download the Linux Anaconda Distribution
wget https://repo.anaconda.com/archive/Anaconda3-2020.11-Linux-x86_64.sh -O /tmp/anaconda3.sh

# Run the installer (installing without -p should automatically install into '/' (root dir)
bash /tmp/anaconda3.sh -b -p /home/ubuntu/anaconda3
rm /tmp/anaconda3.sh

### Run the conda init script to setup the shell
echo ". /home/ubuntu/anaconda3/etc/profile.d/conda.sh" >> /home/ubuntu/.bashrc
. /home/ubuntu/anaconda3/etc/profile.d/conda.sh
source /home/ubuntu/.bashrc

# Create base Python3 environments separate from the base env
conda update -y -n base -c defaults conda
conda create -y --name ada38 python=3.8 
conda create -y --name base38 python=3.8 

# +++++++++++++++++++++ END ANACONDA INSTALL ++++++++++++++++++++++


# ++++++++++++++ SETUP ENV +++++++++++++++

# Install necessary Python packages
# Note that 'source' is deprecated, so now we should be using 'conda' to activate/deactivate envs
conda activate ada38
#conda install -y -c conda-forge awscli
conda install -y -c anaconda urllib3 
conda install -y -c anaconda certifi 
# json?
conda install -y -c anaconda pandas 
conda install -y -c plotly plotly
conda install -y -c conda-forge dash
conda install -y -c anaconda beautifulsoup4
conda install -y -c conda-forge dash-bootstrap-components 
conda install -y -c conda-forge dash-daq

#save current environment settings
conda env export --no-builds > /home/ubuntu/environment.yml

### Setup the credentials for the AWS CLI
##aws configure set aws_access_key_id $1
##aws configure set aws_secret_access_key $2

# ++++++++++++++ END SETUP ENV +++++++++++++++

# ++++++++++++++ SETUP CODE +++++++++++++++
cd /home/ubuntu
mkdir plotlydash
cd plotlydash
mkdir code
mkdir output

cd /home/ubuntu
wget http://download.pvln.nl/python/fastfood/code/show_selection_and_point_on_map_dynamic.py -O /home/ubuntu/plotlydash/code/app.py
wget http://download.pvln.nl/python/fastfood/output/_FastFood.csv -O /home/ubuntu/plotlydash/output/_FastFood.csv

echo "#/bin/bash" >/home/ubuntu/start.sh
echo "# code assumes to be run from within plotlydash/code folder">>/home/ubuntu/start.sh
echo "cd /home/ubuntu/plotlydash/code">>/home/ubuntu/start.sh
echo "ls -la">>/home/ubuntu/start.sh
echo "/home/ubuntu/anaconda3/envs/ada38/bin/python3 --version">>/home/ubuntu/start.sh
echo "/home/ubuntu/anaconda3/envs/ada38/bin/python3 app.py">>/home/ubuntu/start.sh
chmod +x start.sh

# ++++++++++++ END  +++++++++++++
