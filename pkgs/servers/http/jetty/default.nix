{stdenv, fetchurl, unzip}:

stdenv.mkDerivation {
  name = "jetty-5.1.3";

  builder = ./bin-builder.sh;
  buildInputs = [unzip];

  src = fetchurl {
    url = http://puzzle.dl.sourceforge.net/sourceforge/jetty/jetty-5.1.3.zip;
    md5 = "24d1d3163795a7e2390c9e711c919180";
  };
}
