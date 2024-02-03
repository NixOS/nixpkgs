{ lib
, stdenvNoCC
, fetchurl
, _7zz
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "aldente";
  version = "1.24.1";

  src = fetchurl {
    url = "https://github.com/davidwernhart/aldente-charge-limiter/releases/download/${finalAttrs.version}/AlDente.dmg";
    hash = "sha256-vOv52SrUki2f9vGzYy8dhVJVxna2ZvhtG6WbKjCv3gA=";
  };

  dontBuild = true;
  dontFixup = true;

  nativeBuildInputs = [ _7zz ];

  # AlDente.dmg is APFS formatted, unpack with 7zz
  unpackCmd = ''
    runHook preUnpack

    7zz x $src

    runHook postUnpack
  '';

  sourceRoot = "AlDente.app";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications/AlDente.app
    cp -R . $out/Applications/AlDente.app

    runHook postInstall
  '';

  meta = {
    description = "macOS tool to limit maximum charging percentage";
    homepage = "https://apphousekitchen.com";
    changelog = "https://github.com/davidwernhart/aldente-charge-limiter/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [ unfree ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ stepbrobd ];
    platforms = [ "aarch64-darwin" "x86_64-darwin" ];
  };
})
