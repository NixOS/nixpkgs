{ install-wrapper, mkDerivation, patchesRoot, buildPackages, buildFreebsd, compatIfNeeded, libmd, ... }:
let
  binstall = buildPackages.writeShellScript "binstall" (install-wrapper + ''@out@/bin/xinstall "''${args[@]}"'');
in mkDerivation {
  pname = "xinstall-bootstrap";
  path = "usr.bin/xinstall";
  extraPaths = [ "contrib/mtree" "contrib/libc-vis" "lib/libnetbsd" ];
  nativeBuildInputs = [
    buildPackages.bsdSetupHook buildFreebsd.freebsdSetupHook
    buildFreebsd.bmakeMinimal buildPackages.mandoc buildPackages.groff
  ];
  patches = [ /${patchesRoot}/install-bootstrap-Makefile.patch ];
  postPatch = ''
    ln -s $BSDSRCDIR/contrib/mtree/getid.c $BSDSRCDIR/usr.bin/xinstall/
    ln -s $BSDSRCDIR/contrib/mtree/mtree.h $BSDSRCDIR/usr.bin/xinstall/
    ln -s $BSDSRCDIR/contrib/mtree/extern.h $BSDSRCDIR/usr.bin/xinstall/
  '';
  skipIncludesPhase = true;
  buildInputs = compatIfNeeded ++ [libmd];
  buildPhase = ''
    make -C $BSDSRCDIR/usr.bin/xinstall STRIP=-s MK_WERROR=no TESTDIR=${builtins.placeholder "test"} BOOTSTRAPPING=1
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp $BSDSRCDIR/usr.bin/xinstall/xinstall $out/bin/xinstall
    cp ${binstall} $out/bin/binstall
    chmod +x $out/bin/binstall
    substituteInPlace $out/bin/binstall --subst-var out
    ln -s ./binstall $out/bin/install
  '';
  outputs = [ "out" ];
}
