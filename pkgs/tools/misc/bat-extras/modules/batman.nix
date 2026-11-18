{
  lib,
  stdenv,
  buildBatExtrasPkg,
  util-linux,
}:
buildBatExtrasPkg {
  name = "batman";
  dependencies = lib.optional stdenv.targetPlatform.isLinux util-linux;
  shellInit = {
    flags = [ "--export-env" ];
  };
  meta.description = "Read system manual pages (man) using bat as the manual page formatter";
}
