{ fetchurl, stdenv, gettext, perl, pkgconfig, libxml2, pango, cairo }:

stdenv.mkDerivation {
  name = "rrdtool-1.3.6";
  src = fetchurl {
    url = http://oss.oetiker.ch/rrdtool/pub/rrdtool-1.3.6.tar.gz;
    sha256 = "e958760cb0d182c53a878cb2ba5c290c252c2c506082c988e5dd3f3301b895a2";
  };
  buildInputs = [ gettext perl pkgconfig libxml2 pango cairo ];

  meta = {
    homepage = http://oss.oetiker.ch/rrdtool/;
    description = "High performance logging in Round Robin Databases";
    license = "GPL";
    platforms = stdenv.lib.platforms.all;
  };
}
