{stdenv, fetchurl, unzip}:

stdenv.mkDerivation {
  name = "jetty-6.1.4";

  builder = ./bin-builder.sh;
  buildInputs = [unzip];

  src = fetchurl {
    url = mirror://sourceforge/jetty/jetty-6.1.4.zip;
    sha256 = "061cx442g5a5szzms9zhnfmr4aipmqyy9r8m5r84gr79gz9z6dv0";
  };
}
