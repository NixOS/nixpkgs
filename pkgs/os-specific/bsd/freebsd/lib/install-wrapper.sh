set -eu

args=()
declare -i path_args=0

while (( $# )); do
  if (( $# == 1 )); then
    if (( path_args > 1)) || [[ "$1" = */ ]]; then
      mkdir -p "$1"
    else
      mkdir -p "$(dirname "$1")"
    fi
  fi
  case $1 in
    -C) ;;
    -o | -g) shift ;;
    -s) ;;
    -m | -l)
      # handle next arg so not counted as path arg
      args+=("$1" "$2")
      shift
      ;;
    -*) args+=("$1") ;;
    *)
      path_args+=1
      args+=("$1")
      ;;
  esac
  shift
done
