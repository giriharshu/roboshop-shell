script=$(realpath "$0")
echo ${script}
script_path=$(dirname "$script")
source ${script_path}/common.sh

component=user
schema_setup=mongo
function_nodejs



