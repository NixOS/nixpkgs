{stdenv, fetchurl, unzip}:

stdenv.mkDerivation {
  name = "jetty-6.1.21";

  builder = ./bin-builder.sh;
  buildInputs = [unzip];

  src = fetchurl {
    url = http://dist.codehaus.org/jetty/jetty-6.1.21/jetty-6.1.21.zip;
    sha256 = "1nrjglrmf29m1j1c80nskngmlqmc5vc7c48fggczn605l722cwaw";
  };
}
