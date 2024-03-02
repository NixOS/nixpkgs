{ lib
, fetchurl
, undmg
, stdenv
, metaCommon ? { }
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gitx-bin";
  version = "1.0";
  src =
    let
      base = "https://github.com/gitx/gitx/releases/download";
    in
      {
        aarch64-darwin = fetchurl {
          url = "${base}/${finalAttrs.version}/GitX-arm64.dmg";
          hash = "sha256-HAr1rxvv9BGnyvwrLJOu1D7NyeEHSyqH2MQXlCnGQxM=";
        };
        x86_64-darwin = fetchurl {
          url = "${base}/${finalAttrs.version}/GitX-x86_64.dmg";
          hash = "sha256-5U8wOQmn6tzxoHGOd763i7Q8qNXLdiPAFoC2xxjzurU=";
        };
      }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  sourceRoot = "GitX.app";

  nativeBuildInputs = [ undmg ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/GitX.app"
    cp -R . "$out/Applications/GitX.app"
    mkdir "$out/bin"
    ln -s "$out/Applications/GitX.app/Contents/MacOS/GitX" "$out/bin/${finalAttrs.pname}"

    runHook postInstall
  '';

  meta = with lib; {
    description = "The best fork of the best lightweight, visual git client for macOS.";
    homepage = "https://gitx.github.io";
    license = licenses.gpl2;
    maintainers = with maintainers; [ yamashitax ];
    platforms = platforms.darwin;
    hydraPlatforms = [];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
})
