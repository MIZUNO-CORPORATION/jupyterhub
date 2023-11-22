# usage: bash create_kernel.sh {dir-path} {kernel-name} {option: --no-share}
cd $1
if [ ! -d $1/.venv/bin ] ; then
  echo "The venv was not found in $1!"
  exit 1
fi

ENV_PATH=$1
ENV_NAME=$2
shift
shift

source $ENV_PATH/.venv/bin/activate
pip install ipykernel

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
            ipython kernel install --user --name=$ENV_NAME
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
$ENV_PATH/.venv/bin/python -m ipykernel install --name "$ENV_NAME" --display-name "Python ($ENV_NAME)" --prefix=/opt/jupyterhub/

