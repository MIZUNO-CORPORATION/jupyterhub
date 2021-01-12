# usage: bash create_kernel.sh {envname} {option: --no-share}
if [ ! -d ~/.conda/envs/$1 ] ; then
  echo "The conda environment named $1 does not exist!"
  exit 1
fi

ENV_NAME=$1
shift

source /opt/conda/etc/profile.d/conda.sh
conda install -n $ENV_NAME ipykernel -y

# parse option
OPT=`getopt -o n -l no-share -- "$@"`
if [ $? != 0 ] ; then
    exit 1
fi
eval set -- "$OPT"

while true
do
    case $1 in
        -n | --no-share)
            # no share 
            ~/.conda/envs/$ENV_NAME/bin/python -m ipykernel install --name "$ENV_NAME" --display-name "Python ($ENV_NAME)"
            exit 0
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Internal error!" 1>&2
            exit 1
            ;;
    esac
done

# share
~/.conda/envs/$ENV_NAME/bin/python -m ipykernel install --name "$ENV_NAME" --display-name "Python ($ENV_NAME)" --prefix=/opt/jupyterhub/
