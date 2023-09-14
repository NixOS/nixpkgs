{ stdenv, lib, mkDerivation }:
mkDerivation {
  path = "contrib/bmake";
  version = "9.2";
  postPatch = ''
    # make needs this to pick up our sys make files
    export NIX_CFLAGS_COMPILE+=" -D_PATH_DEFSYSPATH=\"$out/share/mk\" -D_GNU_SOURCE"

    sed -e '/unexport-env/d' -e '/opt-keep-going/d' -i contrib/bmake/unit-tests/Makefile
  '' + lib.optionalString stdenv.isDarwin ''
    substituteInPlace $BSDSRCDIR/share/mk/bsd.sys.mk \
      --replace '-Wl,--fatal-warnings' "" \
      --replace '-Wl,--warn-shared-textrel' ""
  '';
  postInstall = ''
    make -C $BSDSRCDIR/share/mk FILESDIR=$out/share/mk install
  '';
  extraPaths = [ "share/mk" "sys/conf/newvers.sh" "sys/sys/param.h" ]
    ++ lib.optional (!stdenv.hostPlatform.isFreeBSD) "tools/build/mk";
}
