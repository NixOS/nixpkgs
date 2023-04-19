{ lib, stdenv, fetchurl, cpio, xar, undmg, ... }:

stdenv.mkDerivation rec {
  pname = "rectangle";
  version = "0.67";

  src = fetchurl {
    url = "https://github.com/rxhanson/Rectangle/releases/download/v${version}/Rectangle${version}.dmg";
    hash = "sha256-tvxGDfpHu86tZt7M055ehEG/lDdmdPmZwrDc2F/yUjk=";
  };

  sourceRoot = "Rectangle.app";

  nativeBuildInputs = [ undmg ];

  installPhase = ''
    mkdir -p $out/Applications/Rectangle.app
    cp -R . $out/Applications/Rectangle.app
  '';

  meta = with lib; {
    description = "Move and resize windows in macOS using keyboard shortcuts or snap areas";
    homepage = "https://rectangleapp.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = platforms.darwin;
    maintainers = with maintainers; [ Enzime ];
    license = licenses.mit;
  };
}

