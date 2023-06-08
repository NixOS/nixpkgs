{ stdenv
, lib
, autoPatchelfHook
, fetchurl
, glfw
}:

let srcs = import ./srcs.nix { inherit fetchurl; }; in
stdenv.mkDerivation {
  pname = "tiltfive-sdk";
  version = srcs.version;

  srcs = srcs.sdk;

  buildInputs = [
    glfw
  ];

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out

    cp -rv * $out/

    chmod 755 $out/Native/lib/linux/x86_64/libTiltFiveNative.so
    chmod 755 $out/Utils/Linux/gameboard_transform

    runHook postInstall
  '';

  meta = with lib; {
    description = "Tilt Five™ Glasses SDK";
    homepage = "https://docs.tiltfive.com/index.html";
    # Non-redistributable. See: license_sdk_en.txt, 2.1.2.
    license = with licenses; unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ q3k ];
    platforms = [ "x86_64-linux" ];
  };
}
