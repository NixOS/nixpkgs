{ lib
, stdenvNoCC
, fetchurl
, _7zz
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "unnaturalscrollwheels";
  version = "1.3.0";

  src = fetchurl {
    url = "https://github.com/ther0n/UnnaturalScrollWheels/releases/download/${finalAttrs.version}/UnnaturalScrollWheels-${finalAttrs.version}.dmg";
    sha256 = "1c6vlf0kc7diz0hb1fmrqaj7kzzfvr65zcchz6xv5cxf0md4n70r";
  };
  sourceRoot = ".";

  # APFS format is unsupported by undmg
  nativeBuildInputs = [ _7zz ];
  unpackCmd = "7zz x $curSrc";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    runHook postInstall
  '';

  meta = with lib; {
    description = "Invert scroll direction for physical scroll wheels";
    homepage = "https://github.com/ther0n/UnnaturalScrollWheels";
    license = licenses.gpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ emilytrau Enzime ];
    platforms = platforms.darwin;
  };
})
