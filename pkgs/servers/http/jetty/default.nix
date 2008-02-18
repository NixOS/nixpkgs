{stdenv, fetchurl, unzip}:

stdenv.mkDerivation {
  name = "jetty-5.1.4";

  builder = ./bin-builder.sh;
  buildInputs = [unzip];

  src = fetchurl {
    url = mirror://sourceforge/jetty/jetty-5.1.4.zip;
    md5 = "5d16bb1ea4a62dff93c0b7f7de00430f";
  };
}
