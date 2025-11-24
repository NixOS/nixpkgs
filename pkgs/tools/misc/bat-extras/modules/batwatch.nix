{
  lib,
  buildBatExtrasPkg,
  less,
  coreutils,
  entr,

  withEntr ? true,
}:
buildBatExtrasPkg {
  name = "batwatch";
  dependencies = [
    less
    coreutils
  ]
  ++ lib.optional withEntr entr;
  meta.description = "Watch for changes in one or more files, and print them with bat";
}
