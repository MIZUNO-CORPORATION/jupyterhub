# add user for jupyterhub
# usage: sudo bash add_user.sh {username}

# use openssl to generate encrypted password https://unix.stackexchange.com/questions/57796/how-can-i-assign-an-initial-default-password-to-a-user-in-linux#comment79705_57804
sudo useradd -g jupyter $1 -m -p $(openssl passwd -1 "password") -s /bin/bash
        
# change permision root to user and group
sudo chown -R $1:jupyter /home/$1

sudo cat /home/adminserver/jupyterhub/bash-sh.txt >> /home/$1/.bashrc
sudo ln -s /home/adminserver/jupyterhub/create_kernel.sh /home/$1/
sudo ln -s /home/adminserver/jupyterhub/manual.md /home/$1/
sudo ln -s /opt/shared /home/$1/
