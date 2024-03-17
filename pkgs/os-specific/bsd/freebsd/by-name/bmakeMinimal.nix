{ lib, stdenv, mkDerivation, bsdSetupHook, freebsdSetupHook, patchesRoot, hostVersion, ... }:
mkDerivation {
  path = "contrib/bmake";
  extraPaths = [ "share/mk" ]
    ++ lib.optional (!stdenv.hostPlatform.isFreeBSD) "tools/build/mk";

  buildInputs = [];
  nativeBuildInputs = [ bsdSetupHook freebsdSetupHook ];

  skipIncludesPhase = true;

  makeFlags = [];

  patches = [
    /${patchesRoot}/bmake-no-compiler-rt.patch
  ];

  postPatch = ''
    patchShebangs configure
    # make needs this to pick up our sys make files
    export NIX_CFLAGS_COMPILE+=" -D_PATH_DEFSYSPATH=\"$out/share/mk\""

    # Copied from netbsd. we need to prevent it from trying to adjust the permissions of installed files.
    #set +e
    #find $BSDSRCDIR -print0 -name '*.mk' | while IFS= read -r -d "" f; do
    #  echo $f
    #  substituteInPlace "$f" \
    #    --replace '-o ''${DOCOWN}' "" \
    #    --replace '-g ''${DOCGRP}' "" \
    #    --replace '-o ''${BINOWN}' "" \
    #    --replace '-g ''${BINGRP}' "" \
    #    --replace '-o ''${RUMPBINOWN}' "" \
    #    --replace '-g ''${RUMPBINGRP}' "" \
    #    --replace '-o ''${DEBUGOWN}' "" \
    #    --replace '-g ''${DEBUGGRP}' "" \
    #    --replace '-o ''${KMODULEOWN}' "" \
    #    --replace '-g ''${KMODULEGRP}' "" \
    #    --replace '-o ''${LIBOWN}' "" \
    #    --replace '-g ''${LIBGRP}' "" \
    #    --replace '-o ''${MANOWN}' "" \
    #    --replace '-g ''${MANGRP}' "" \
    #    --replace '-o ''${NLSOWN}' "" \
    #    --replace '-g ''${NLSGRP}' ""
    #done
    #set -e
  '' + lib.optionalString stdenv.isDarwin ''
    substituteInPlace $BSDSRCDIR/share/mk/bsd.sys.mk \
      --replace '-Wl,--fatal-warnings' "" \
      --replace '-Wl,--warn-shared-textrel' ""
  '' + lib.optionalString (stdenv.targetPlatform.isFreeBSD && hostVersion != "13.2") ''
    substituteInPlace $BSDSRCDIR/share/mk/local.sys.dirdeps.env.mk \
      --replace 'MK_host_egacy= yes' 'MK_host_egacy= no'
  '';

  configureFlags = ["--with-filemon=no"];

  buildPhase = ''
    runHook preBuild

    sh ./make-bootstrap.sh

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D bmake "$out/bin/bmake"
    ln -s "$out/bin/bmake" "$out/bin/make"
    mkdir -p "$out/share"
    cp -r "$BSDSRCDIR/share/mk" "$out/share/mk"
    find "$out/share/mk" -type f -print0 |
      while IFS= read -r -d "" f; do
        substituteInPlace "$f" --replace 'usr/' ""
      done
    substituteInPlace "$out/share/mk/bsd.symver.mk" \
      --replace '/share/mk' "$out/share/mk"

    runHook postInstall
  '';

  postInstall = lib.optionalString (!stdenv.targetPlatform.isFreeBSD) ''
    boot_mk="$BSDSRCDIR/tools/build/mk"
    cp "$boot_mk"/Makefile.boot* "$out/share/mk"
    replaced_mk="$out/share/mk.orig"
    mkdir "$replaced_mk"
    mv "$out"/share/mk/bsd.{lib,prog}.mk "$replaced_mk"
    for m in bsd.{lib,prog}.mk; do
      cp "$boot_mk/$m" "$out/share/mk"
      substituteInPlace "$out/share/mk/$m" --replace '../../../share/mk' '../mk.orig'
    done
  '';
}
