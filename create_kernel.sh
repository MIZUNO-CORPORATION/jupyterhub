# usage: bash create_kernel.sh {envname}
if [ ! -d /opt/conda/envs/$1 ] ; then
  echo "The conda environment named $1 does not exist!"
  exit 1
fi


conda activate $1
conda install ipykernel -y

/opt/conda/envs/$1/bin/python -m ipykernel install --name "$1" --display-name "Python ($1)" --prefix=/opt/jupyterhub/
