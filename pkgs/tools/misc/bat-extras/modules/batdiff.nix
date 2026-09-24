{
  lib,
  buildBatExtrasPkg,
  less,
  coreutils,
  gitMinimal,
  delta,
  withDelta ? true,
}:
buildBatExtrasPkg {
  name = "batdiff";
  dependencies = [
    less
    coreutils
    gitMinimal
  ]
  ++ lib.optional withDelta delta;
  meta.description = "Diff a file against the current git index, or display the diff between two files";
}
