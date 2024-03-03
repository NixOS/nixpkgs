{ lib, stdenv, fetchurl, libarchive, p7zip }:
stdenv.mkDerivation (finalAttrs: {
  pname = "dockutil";
  version = "3.1.3";

  src = fetchurl {
    url =
      "https://github.com/kcrawford/dockutil/releases/download/${finalAttrs.version}/dockutil-${finalAttrs.version}.pkg";
    hash = "sha256-9g24Jz/oDXxIJFiL7bU4pTh2dcORftsAENq59S0/JYI=";
  };

  dontBuild = true;

  nativeBuildInputs = [ libarchive p7zip ];

  unpackCmd = "7z x -so $src | bsdtar -x";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mkdir -p $out/usr/local/bin
    install -Dm755 local/bin/dockutil -t $out/usr/local/bin
    ln -rs $out/usr/local/bin/dockutil $out/bin/dockutil
    runHook postInstall
  '';

  meta = with lib; {
    description = "Tool for managing dock items";
    homepage = "https://github.com/kcrawford/dockutil";
    license = licenses.asl20;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ tboerger ];
    mainProgram = "dockutil";
    platforms = platforms.darwin;
  };
})
