{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "anthy-9100h";

  meta = with stdenv.lib; {
    description = "Hiragana text to Kana Kanji mixed text Japanese input method";
    homepace    = http://sourceforge.jp/projects/anthy/;
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ ericsagnes ];
    platforms   = platforms.linux;
  };

  src = fetchurl {
    url = "http://dl.sourceforge.jp/anthy/37536/anthy-9100h.tar.gz";
    sha256 = "0ism4zibcsa5nl77wwi12vdsfjys3waxcphn1p5s7d0qy1sz0mnj";
  };
}
