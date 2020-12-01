# delete user
# usage: sudo bash delete_user.sh {username}
sudo userdel -r $1
/bin/su "passwd --delete $1"
