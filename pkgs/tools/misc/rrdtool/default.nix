{ fetchurl, stdenv, gettext, perl, pkgconfig, libxml2, pango, cairo }:

stdenv.mkDerivation {
  name = "rrdtool-1.4.5";
  src = fetchurl {
    url = http://oss.oetiker.ch/rrdtool/pub/rrdtool-1.4.5.tar.gz;
    sha256 = "07fgn0y4yj7p2vh6a37q273hf98gkfw2sdam5r1ldn1k0m1ayrqj";
  };
  buildInputs = [ gettext perl pkgconfig libxml2 pango cairo ];

  meta = {
    homepage = http://oss.oetiker.ch/rrdtool/;
    description = "High performance logging in Round Robin Databases";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
