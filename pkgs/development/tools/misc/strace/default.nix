{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "strace-4.5.16";

  src = fetchurl {
    url = mirror://sourceforge/strace/strace-4.5.16.tar.bz2;
    sha256 = "15ks9i1gv7mbyiwnzbjls2xy0pyv5x4j9a5ca2x0258fq8lxwdhp";
  };
}
