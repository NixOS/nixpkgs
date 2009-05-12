{stdenv, fetchurl, qt4}:

stdenv.mkDerivation rec {
  pkgname = "wpa_supplicant";
  version = "0.6.9";
  name = "${pkgname}-gui-qt4-${version}";

  src = fetchurl {
    url = "http://hostap.epitest.fi/releases/${pkgname}-${version}.tar.gz";
    sha256 = "0w7mf3nyilkjsn5v7p15v5fxnh0klgm8c979z80y0mkw7zx88lkf";
  };

  buildInputs = [qt4];  
  builder = ./builder-gui-qt4.sh;  
}
