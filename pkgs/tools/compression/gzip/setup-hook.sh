# shellcheck shell=bash

# If strictDeps is unset or our host offset belongs to a native platform,
# we assume that we can run gzip and register with unpackCmdHooks; otherwise,
# return because we cannot assume gzip can run on this platform.
[[ -z ${strictDeps-} ]] || (( hostOffset < 0 )) || return 0

# Unpacks a GZIP file to the current directory. The file name is the same as the archive,
# but without the ".gz" extension. The original file is not deleted.
_tryUngzip() {
  [[ "$1" = *.gz ]] && gzip --keep --decompress --stdout "$1" > "$(basename "$1" .gz)"
}

unpackCmdHooks+=(_tryUngzip)
