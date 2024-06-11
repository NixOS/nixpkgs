{
  lib,
  mkDerivation,
  fetchNetBSD,
  stdenv,
  make-rules,
}:

mkDerivation {
  path = "usr.bin/make";
  sha256 = "0vi73yicbmbp522qzqvd979cx6zm5jakhy77xh73c1kygf8klccs";
  version = "9.2";

  postPatch =
    make-rules.postPatch
    + ''
      # make needs this to pick up our sys make files
      appendToVar NIX_CFLAGS_COMPILE "-D_PATH_DEFSYSPATH=\"$out/share/mk\""
    '';

  postInstall = ''
    make -C $BSDSRCDIR/share/mk FILESDIR=$out/share/mk install
  '';
  extraPaths = [
    (fetchNetBSD "share/mk" "9.2" "0w9x77cfnm6zwy40slradzi0ip9gz80x6lk7pvnlxzsr2m5ra5sy")
  ];
}
