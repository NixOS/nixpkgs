addHareToolpath() {
  local -r toolpath="${1-}/libexec/hare"
  if [[ -d "$toolpath" ]]; then
    addToSearchPath HARE_TOOLPATH "$toolpath"
  fi
}

addEnvHooks "$hostOffset" addHareToolpath
