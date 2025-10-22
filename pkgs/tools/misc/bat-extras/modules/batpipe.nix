{
  buildBatExtrasPkg,
  less,
  procps,
}:
buildBatExtrasPkg {
  name = "batpipe";
  dependencies = [
    less
    procps
  ];
  patches = [
    ../patches/batpipe-skip-outdated-test.patch
  ];
  meta.description = "Less (and soon bat) preprocessor for viewing more types of files in the terminal";
}
