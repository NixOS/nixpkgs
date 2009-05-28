{stdenv, fetchurl, pkgconfig, libgsf, glib, libxml2}:

stdenv.mkDerivation {
  name = "wv2-0.3.1";
  src = fetchurl {
    url = mirror://sourceforge/wvware/wv2-0.3.1.tar.bz2;
    sha256 = "896ff8ec59e280e8cb1ef9a953b364845dd65de1cdf8e4ed8a7e045a3f81c546";
  };
  buildInputs = [ pkgconfig libgsf glib libxml2 ];
}
