{ lib
, stdenvNoCC
, fetchurl
, undmg
}:

stdenvNoCC.mkDerivation rec {
  pname = "raycast";
  version = "1.53.4";

  src = fetchurl {
    name = "Raycast.dmg";
    url = "https://releases.raycast.com/releases/${version}/download?build=universal";
    sha256 = "sha256-bkNlGHCpYnHlKdzDyKGPF5jnoq2cSe1sdg9W2DwVrWc=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  nativeBuildInputs = [ undmg ];

  sourceRoot = "Raycast.app";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications/Raycast.app
    cp -R . $out/Applications/Raycast.app

    runHook postInstall
  '';

  meta = with lib; {
    description = "Control your tools with a few keystrokes";
    homepage = "https://raycast.app/";
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ lovesegfault stepbrobd ];
    platforms = platforms.darwin;
  };
}
