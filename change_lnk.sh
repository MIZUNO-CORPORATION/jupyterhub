function include_homedir {
  local list="$1"
  local item="$2"
  if [[ $list =~ (^|[[:space:]])"$item"($|[[:space:]]) ]] ; then
    # yes, list include item
    result=0
  else
    result=1
  fi
  return $result
}

for d in /home/*; do
    if `include_homedir "guest intern2024win" "${d#/home/}"` ; then
	echo "external $d"
	sudo ln -sf /opt/sharedall/jupyterhub/create_kernel.sh $d/
	sudo ln -sf /opt/sharedall/jupyterhub/manual_external.md $d/
	sudo chown adminserver:jupyter $d/create_kernel.sh
	sudo chmod 555 $d/create_kernel.sh
	sudo chown adminserver:jupyter $d/manual_external.md
	sudo chmod 555 $d/manual_external.md
    else
	echo "inhouse $d"
	sudo ln -sf /opt/sharedall/jupyterhub/create_kernel.sh $d/
	sudo ln -sf /opt/sharedall/jupyterhub/manual.md $d/
	sudo chown adminserver:jupyter $d/create_kernel.sh
        sudo chmod 555 $d/create_kernel.sh
        sudo chown adminserver:jupyter $d/manual.md
        sudo chmod 555 $d/manual.md
    fi
done
