{ lib
, stdenvNoCC
, fetchurl
, unzip
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "hammerspoon";
  version = "0.9.100";

  src = fetchurl {
    name = "Hammerspoon-${finalAttrs.version}.zip";
    url = "https://github.com/Hammerspoon/hammerspoon/releases/download/${finalAttrs.version}/Hammerspoon-${finalAttrs.version}.zip";
    hash = "sha256-bc/IB8fOxpLK87GMNsweo69rn0Jpm03yd3NECOTgc5k=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  nativeBuildInputs = [ unzip ];

  sourceRoot = "Hammerspoon.app";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/${finalAttrs.sourceRoot}"
    cp -R . "$out/Applications/${finalAttrs.sourceRoot}"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Tool for powerful automation of macOS";
    longDescription = ''
      Hammerspoon is just a bridge between the operating system and a Lua scripting engine.
      What gives Hammerspoon its power is a set of extensions that expose specific pieces of system functionality, to the user.
    '';
    homepage = "http://www.hammerspoon.org";
    changelog = "http://www.hammerspoon.org/releasenotes/${finalAttrs.version}.html";
    license = with licenses; [ mit ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ afh ];
    platforms = [ "aarch64-darwin" "x86_64-darwin" ];
  };
})
