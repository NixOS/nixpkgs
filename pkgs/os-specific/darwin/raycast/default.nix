{ lib
, stdenvNoCC
, fetchurl
, undmg
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "raycast";
  version = "1.59.0";

  src = fetchurl {
    name = "Raycast.dmg";
    url = "https://releases.raycast.com/releases/${finalAttrs.version}/download?build=universal";
    hash = "sha256-EA8DzfJtd1lM0/N1bQ8x9GQ8KiILwRKPIFKk6XlaBhg=";
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
    license = with licenses; [ unfree ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ lovesegfault stepbrobd ];
    platforms = [ "aarch64-darwin" "x86_64-darwin" ];
  };
})
