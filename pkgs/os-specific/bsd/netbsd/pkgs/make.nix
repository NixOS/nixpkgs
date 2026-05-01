{ mkDerivation, make-rules }:

mkDerivation {
  path = "usr.bin/make";

  postPatch = make-rules.postPatch + ''
    # make needs this to pick up our sys make files
    appendToVar NIX_CFLAGS_COMPILE "-D_PATH_DEFSYSPATH=\"$out/share/mk\""
  '';

  postInstall = ''
    make -C $BSDSRCDIR/share/mk FILESDIR=$out/share/mk install
  '';
  extraPaths = [ "share/mk" ];
}
