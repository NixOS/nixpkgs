# shellcheck shell=bash
mkdirp() {
  mkdir -p "$@"
  echo "$@"
}
