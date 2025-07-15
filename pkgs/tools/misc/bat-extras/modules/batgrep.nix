{
  buildBatExtrasPkg,
  less,
  coreutils,
  ripgrep,
}:
buildBatExtrasPkg {
  name = "batgrep";
  dependencies = [
    less
    coreutils
    ripgrep
  ];
  meta.description = "Quickly search through and highlight files using ripgrep";
}
