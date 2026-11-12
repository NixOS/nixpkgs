{
  lib,
  bin,
  writeScriptBin,
}:
writeScriptBin "freebsd_wordexp" ''
  #!${lib.getBin bin}/bin/sh
  freebsd_wordexp "$@"
''
