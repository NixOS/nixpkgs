{ lib
, stdenvNoCC
, fetchurl
, undmg
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "airbuddy";
  version = "2.6.3";

  src = fetchurl {
    name = "AirBuddy.dmg";
    url = "https://download.airbuddy.app/WebDownload/AirBuddy_v${finalAttrs.version}.dmg";
    hash = "sha256-q/Mbkm90ptIkdTLV2KDT9CM2Hsxnkway5Fw0F6d7Tqc=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  nativeBuildInputs = [ undmg ];

  sourceRoot = "AirBuddy.app";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications/AirBuddy.app
    cp -R . $out/Applications/AirBuddy.app

    runHook postInstall
  '';

  meta = with lib; {
    description = "Take Control of Your Wireless Devices on macOS";
    longDescription = ''
      Open your AirPods case next to your Mac to see the status right away, just like it works on your iPhone or iPad.
      AirBuddy lives in your Menu Bar and can also show battery information for your iPhone, iPad, Apple Watch, Mouse, Keyboard, and more.
    '';
    homepage = "https://v2.airbuddy.app";
    changelog = "https://support.airbuddy.app/articles/airbuddy-2-changelog";
    license = with licenses; [ unfree ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ stepbrobd ];
    platforms = [ "aarch64-darwin" "x86_64-darwin" ];
  };
})
