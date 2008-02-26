{stdenv, fetchurl, unzip}:

stdenv.mkDerivation {
  name = "jetty-6.1.3";

  builder = ./bin-builder.sh;
  buildInputs = [unzip];

  src = fetchurl {
    url = http://dist.codehaus.org/jetty/jetty-6.1.x/jetty-6.1.3.zip;
    md5 = "bb39bba9ce017e7cd3996cb3e83e8971";
  };
}
