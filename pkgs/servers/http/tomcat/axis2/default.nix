{stdenv, fetchurl, apacheAnt, jdk, unzip}:

stdenv.mkDerivation {
  name = "axis2-1.6.2";

  src = fetchurl {
    url = http://apache.proserve.nl//axis/axis2/java/core/1.6.2/axis2-1.6.2-bin.zip;
    sha256 = "02i6fv11ksd5ql81i501bcb11ib5gyhq3zxwrz5jm4ic80r097fp";
  };

  buildInputs = [ unzip apacheAnt jdk ];
  builder = ./builder.sh;
}
