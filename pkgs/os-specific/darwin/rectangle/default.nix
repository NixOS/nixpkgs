{ lib, stdenv, fetchurl, cpio, xar, undmg, ... }:

stdenv.mkDerivation rec {
  pname = "rectangle";
  version = "0.59";

  src = fetchurl {
    url = "https://github.com/rxhanson/Rectangle/releases/download/v${version}/Rectangle${version}.dmg";
    sha256 = "sha256-6K4HJ4qWjf/BsoxmSWyO/Km3BZujCnMJ2/xCMkH3TaI=";
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

