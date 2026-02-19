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
  # The tests are broken with the new bat 0.26.0
  # https://github.com/eth-p/bat-extras/issues/143
  doCheck = false;
  meta.description = "Quickly search through and highlight files using ripgrep";
}
