#! @runtimeShell@
set -eou pipefail

recursive=false
positional_args=()
nix_args=()
flake=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --help)
      exec man -l @nixosOptionManpage@
      ;;

    -r|--recursive)
      recursive=true
      shift
      ;;

    -I)
      nix_args+=("$1" "$2")
      shift 2
      ;;

    -F|--flake)
      flake=$2
      shift 2
      ;;

    --show-trace)
      nix_args+=("$1")
      shift
      ;;

    -*)
      echo >&2 "Unsupported option $1"
      exit 1
      ;;

    *)
      positional_args+=("$1")
      shift
      ;;
  esac
done

if [ -z "$flake" ] && [ -e /etc/nixos/flake.nix ]; then
  flake="$(dirname "$(readlink -f /etc/nixos/flake.nix)")"
fi
if [ -n "$flake" ]; then
  if [[ $flake =~ ^(.*)\#([^\#\"]*)$ ]]; then
    flake="${BASH_REMATCH[1]}"
    flakeAttr="${BASH_REMATCH[2]}"
  fi
  if [ -z "${flakeAttr:-}" ]; then
    hostname=$(hostname)
    if [ -z "${hostname:-}" ]; then
      hostname=default
    fi
    flakeAttr="nixosConfigurations.\"$hostname\""
  else
    flakeAttr="nixosConfigurations.\"$flakeAttr\""
  fi
  nix_args+=(--arg nixos "(builtins.getFlake \"$flake\").$flakeAttr")
fi

case ${#positional_args[@]} in
  0) path= ;;
  1) path="${positional_args[0]}" ;;
  *) echo >&2 "Only one option path can be provided"; exit 1 ;;
esac

@nixInstantiate@ "${nix_args[@]}" --eval --json \
    --argstr path "$path" \
    --arg recursive "$recursive" \
    @nixosOptionNix@ \
| @jq@ -r
