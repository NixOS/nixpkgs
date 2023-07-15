{ lib
, stdenvNoCC
, fetchurl
, undmg
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "bartender";
  version = "4.2.21";

  src = fetchurl {
    name = "Bartender 4.dmg";
    url = "https://www.macbartender.com/B2/updates/${builtins.replaceStrings [ "." ] [ "-" ] finalAttrs.version}/Bartender%204.dmg";
    hash = "sha256-KL4Wy8adGiYmxaDkhGJjwobU5szpW2j7ObgHyp02Dow=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  nativeBuildInputs = [ undmg ];

  sourceRoot = "Bartender 4.app";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications/Bartender\ 4.app
    cp -R . $out/Applications/Bartender\ 4.app

    runHook postInstall
  '';

  meta = with lib; {
    description = "Take control of your menu bar";
    longDescription = ''
      Bartender is an award-winning app for macOS that superpowers your menu bar, giving you total control over your menu bar items, what's displayed, and when, with menu bar items only showing when you need them.
      Bartender improves your workflow with quick reveal, search, custom hotkeys and triggers, and lots more.
    '';
    homepage = "https://www.macbartender.com";
    changelog = "https://www.macbartender.com/Bartender4/release_notes";
    license = with licenses; [ unfree ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ stepbrobd ];
    platforms = [ "aarch64-darwin" "x86_64-darwin" ];
  };
})
