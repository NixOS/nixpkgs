{
  lib,
  mkDerivation,
  stdenv,
  bsdSetupHook,
  netbsdSetupHook,
}:

mkDerivation {
  path = "share/mk";
  noCC = true;

  buildInputs = [ ];
  nativeBuildInputs = [
    bsdSetupHook
    netbsdSetupHook
  ];

  dontBuild = true;

  postPatch =
    ''
      substituteInPlace $BSDSRCDIR/share/mk/bsd.doc.mk \
        --replace-fail '-o ''${DOCOWN}' "" \
        --replace-fail '-g ''${DOCGRP}' ""
      for mk in $BSDSRCDIR/share/mk/bsd.inc.mk $BSDSRCDIR/share/mk/bsd.kinc.mk; do
        substituteInPlace $mk \
          --replace-fail '-o ''${BINOWN}' "" \
          --replace-fail '-g ''${BINGRP}' ""
      done
      substituteInPlace $BSDSRCDIR/share/mk/bsd.kmodule.mk \
        --replace-fail '-o ''${KMODULEOWN}' "" \
        --replace-fail '-g ''${KMODULEGRP}' ""
      substituteInPlace $BSDSRCDIR/share/mk/bsd.lib.mk \
        --replace-fail '-o ''${LIBOWN}' "" \
        --replace-fail '-g ''${LIBGRP}' "" \
        --replace-fail '-o ''${DEBUGOWN}' "" \
        --replace-fail '-g ''${DEBUGGRP}' ""
      substituteInPlace $BSDSRCDIR/share/mk/bsd.lua.mk \
        --replace-fail '-o ''${LIBOWN}' "" \
        --replace-fail '-g ''${LIBGRP}' ""
      substituteInPlace $BSDSRCDIR/share/mk/bsd.man.mk \
        --replace-fail '-o ''${MANOWN}' "" \
        --replace-fail '-g ''${MANGRP}' ""
      substituteInPlace $BSDSRCDIR/share/mk/bsd.nls.mk \
        --replace-fail '-o ''${NLSOWN}' "" \
        --replace-fail '-g ''${NLSGRP}' ""
      substituteInPlace $BSDSRCDIR/share/mk/bsd.prog.mk \
        --replace-fail '-o ''${BINOWN}' "" \
        --replace-fail '-g ''${BINGRP}' "" \
        --replace-fail '-o ''${RUMPBINOWN}' "" \
        --replace-fail '-g ''${RUMPBINGRP}' "" \
        --replace-fail '-o ''${DEBUGOWN}' "" \
        --replace-fail '-g ''${DEBUGGRP}' ""

       substituteInPlace $BSDSRCDIR/share/mk/bsd.lib.mk \
         --replace-fail '_INSTRANLIB=''${empty(PRESERVE):?-a "''${RANLIB} -t":}' '_INSTRANLIB='
       substituteInPlace $BSDSRCDIR/share/mk/bsd.kinc.mk \
         --replace-fail /bin/rm rm
    ''
    + lib.optionalString stdenv.targetPlatform.isDarwin ''
      substituteInPlace $BSDSRCDIR/share/mk/bsd.sys.mk \
        --replace-fail '-Wl,--fatal-warnings' "" \
        --replace-fail '-Wl,--warn-shared-textrel' ""
    '';

  installPhase = ''
    cp -r . $out
  '';
}
