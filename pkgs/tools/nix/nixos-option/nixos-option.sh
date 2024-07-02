#! @runtimeShell@
set -eou pipefail

recursive=false
positional_args=()
nix_args=()

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
