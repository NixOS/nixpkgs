{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "anthy";
  version = "9100h";

  meta = with lib; {
    description = "Hiragana text to Kana Kanji mixed text Japanese input method";
    homepage    = "https://anthy.osdn.jp/";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ ericsagnes ];
    platforms   = platforms.unix;
  };

  src = fetchurl {
    url = "mirror://osdn/anthy/37536/anthy-${version}.tar.gz";
    sha256 = "0ism4zibcsa5nl77wwi12vdsfjys3waxcphn1p5s7d0qy1sz0mnj";
  };
}
