{stdenv, fetchurl, xpf, jre, ant}:

stdenv.mkDerivation {
  name = "jclasslib-2.0";
  builder = ./builder.sh;
  src = fetchurl {
    url = mirror://sourceforge/jclasslib/jclasslib_unix_2_0.tar.gz;
    sha256 = "1y2fbg5h2p3fwcp7h5n1qib7x9svyrilq3i58vm6vany1xzg7nx5";
  };

  inherit jre xpf ant;
  buildInputs = [xpf ant];
}
