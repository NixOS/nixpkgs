{ lib
, stdenvNoCC
, fetchurl
, undmg
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "xbar";
  version = "2.1.7-beta";

  src = fetchurl {
    name = "xbar.v${finalAttrs.version}.dmg";
    url = "https://github.com/matryer/xbar/releases/download/v${finalAttrs.version}/xbar.v${finalAttrs.version}.dmg";
    hash = "sha256-Cn6nxA5NTi7M4NrjycN3PUWd31r4Z0T3DES5+ZAbxz8=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  nativeBuildInputs = [ undmg ];

  sourceRoot = "xbar.app";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/${finalAttrs.sourceRoot}"
    cp -R . "$out/Applications/${finalAttrs.sourceRoot}"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Put anything in your macOS menu bar";
    longDescription = ''
      Bartender is an award-winning app for macOS that superpowers your menu bar, giving you total control over your menu bar items, what's displayed, and when, with menu bar items only showing when you need them.
      Bartender improves your workflow with quick reveal, search, custom hotkeys and triggers, and lots more.
    '';
    homepage = "https://xbarapp.com";
    changelog = "https://github.com/matryer/xbar/releases/tag/v${finalAttrs.version}";
    license = with licenses; [ mit ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ afh ];
    platforms = [ "aarch64-darwin" "x86_64-darwin" ];
  };
})
