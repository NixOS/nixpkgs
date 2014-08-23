{stdenv, fetchurl, unzip}:

stdenv.mkDerivation {
  name = "jetty-6.1.26";

  builder = ./bin-builder.sh;
  buildInputs = [unzip];

  src = fetchurl {
    url = http://dist.codehaus.org/jetty/jetty-6.1.26/jetty-6.1.26.zip;
    sha256 = "11w1ciayv8zvxjg45xzs0kwc7k45x97sbnxkqb62sxy3gsw8xh4n";
  };
}
