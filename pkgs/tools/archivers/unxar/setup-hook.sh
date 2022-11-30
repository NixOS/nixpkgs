unpackCmdHooks+=(_tryUnpackXar)
_tryUnpackXar() {
  xar --dump-header -f "${curSrc}" | grep -q "^magic:\s\+[0-9a-z]\+\s\+(OK)$"
  [ $? -ne 0 ] && return 1
  xar -xf "$curSrc"
}
