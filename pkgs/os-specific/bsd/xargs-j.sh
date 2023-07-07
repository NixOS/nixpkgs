#! @shell@

declare -a args=()

token=$1
shift

while (( $# )); do
    if [[ "$1" = "$token" ]]; then
        mapfile -t -O $(("${#args[@]}" + 1)) args
    else
        args+=("$1")
    fi
    shift
done

exec "${args[@]}"
