{ lib, mkDerivation, fetchNetBSD, stdenv }:

mkDerivation {
  path = "usr.bin/make";
  sha256 = "0vi73yicbmbp522qzqvd979cx6zm5jakhy77xh73c1kygf8klccs";
  version = "9.2";

 postPatch = ''
   substituteInPlace $BSDSRCDIR/share/mk/bsd.doc.mk \
     --replace '-o ''${DOCOWN}' "" \
     --replace '-g ''${DOCGRP}' ""
   for mk in $BSDSRCDIR/share/mk/bsd.inc.mk $BSDSRCDIR/share/mk/bsd.kinc.mk; do
     substituteInPlace $mk \
       --replace '-o ''${BINOWN}' "" \
       --replace '-g ''${BINGRP}' ""
   done
   substituteInPlace $BSDSRCDIR/share/mk/bsd.kmodule.mk \
     --replace '-o ''${KMODULEOWN}' "" \
     --replace '-g ''${KMODULEGRP}' ""
   substituteInPlace $BSDSRCDIR/share/mk/bsd.lib.mk \
     --replace '-o ''${LIBOWN}' "" \
     --replace '-g ''${LIBGRP}' "" \
     --replace '-o ''${DEBUGOWN}' "" \
     --replace '-g ''${DEBUGGRP}' ""
   substituteInPlace $BSDSRCDIR/share/mk/bsd.lua.mk \
     --replace '-o ''${LIBOWN}' "" \
     --replace '-g ''${LIBGRP}' ""
   substituteInPlace $BSDSRCDIR/share/mk/bsd.man.mk \
     --replace '-o ''${MANOWN}' "" \
     --replace '-g ''${MANGRP}' ""
   substituteInPlace $BSDSRCDIR/share/mk/bsd.nls.mk \
     --replace '-o ''${NLSOWN}' "" \
     --replace '-g ''${NLSGRP}' ""
   substituteInPlace $BSDSRCDIR/share/mk/bsd.prog.mk \
     --replace '-o ''${BINOWN}' "" \
     --replace '-g ''${BINGRP}' "" \
     --replace '-o ''${RUMPBINOWN}' "" \
     --replace '-g ''${RUMPBINGRP}' "" \
     --replace '-o ''${DEBUGOWN}' "" \
     --replace '-g ''${DEBUGGRP}' ""

    # make needs this to pick up our sys make files
    export NIX_CFLAGS_COMPILE+=" -D_PATH_DEFSYSPATH=\"$out/share/mk\""

    substituteInPlace $BSDSRCDIR/share/mk/bsd.lib.mk \
      --replace '_INSTRANLIB=''${empty(PRESERVE):?-a "''${RANLIB} -t":}' '_INSTRANLIB='
    substituteInPlace $BSDSRCDIR/share/mk/bsd.kinc.mk \
      --replace /bin/rm rm
  '' + lib.optionalString stdenv.isDarwin ''
    substituteInPlace $BSDSRCDIR/share/mk/bsd.sys.mk \
      --replace '-Wl,--fatal-warnings' "" \
      --replace '-Wl,--warn-shared-textrel' ""
  '';
  postInstall = ''
    make -C $BSDSRCDIR/share/mk FILESDIR=$out/share/mk install
  '';
  extraPaths = [
    (fetchNetBSD "share/mk" "9.2" "0w9x77cfnm6zwy40slradzi0ip9gz80x6lk7pvnlxzsr2m5ra5sy")
  ];
}
