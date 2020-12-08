# usage: bash create_kernel.sh {envname}
if [ ! -d ~/.conda/envs/$1 ] ; then
  echo "The conda environment named $1 does not exist!"
  exit 1
fi

source /opt/conda/etc/profile.d/conda.sh
conda install -n $1 ipykernel -y

~/.conda/envs/$1/bin/python -m ipykernel install --name "$1" --display-name "Python ($1)" --prefix=/opt/jupyterhub/
