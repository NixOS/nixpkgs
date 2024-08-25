{
  lib,
  mkDerivation,
  stdenv,
}:

mkDerivation {
  path = "contrib/bmake";
  version = "9.2";
  postPatch =
    ''
      # make needs this to pick up our sys make files
      export NIX_CFLAGS_COMPILE+=" -D_PATH_DEFSYSPATH=\"$out/share/mk\""

    ''
    + lib.optionalString stdenv.isDarwin ''
      substituteInPlace $BSDSRCDIR/share/mk/bsd.sys.mk \
        --replace-fail '-Wl,--fatal-warnings' "" \
        --replace-fail '-Wl,--warn-shared-textrel' ""
    '';
  postInstall = ''
    make -C $BSDSRCDIR/share/mk FILESDIR=$out/share/mk install
  '';
  extraPaths = [ "share/mk" ] ++ lib.optional (!stdenv.hostPlatform.isFreeBSD) "tools/build/mk";
}
