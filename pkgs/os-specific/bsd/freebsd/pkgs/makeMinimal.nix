{ lib, stdenv, mkDerivation
, make
, bsdSetupHook, freebsdSetupHook
}:

mkDerivation rec {
  inherit (make) path;

  buildInputs = [];
  nativeBuildInputs = [
    bsdSetupHook freebsdSetupHook
  ];

  skipIncludesPhase = true;

  makeFlags = [];

  postPatch = ''
    patchShebangs configure
    ${make.postPatch}
  '';

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

  extraPaths = make.extraPaths;
}
