# for changing anaconda into pyenv+pip
# usage: sudo bash to_pyenv.sh {username}


# copy pyenv
sudo cp -r /home/adminserver/.pyenv /home/$1/
sudo chown -R $1:jupyter /home/$1/.pyenv

sudo cat /home/adminserver/jupyterhub/bash-sh.txt >> /home/$1/.bashrc
# remove create_kernel.sh
sudo rm /home/$1/create_kernel.sh
