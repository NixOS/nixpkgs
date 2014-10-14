{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "netcat-gnu-0.7.1";
  src = fetchurl {
    url = mirror://sourceforge/netcat/netcat-0.7.1.tar.bz2;
    sha256 = "1frjcdkhkpzk0f84hx6hmw5l0ynpmji8vcbaxg8h5k2svyxz0nmm";
  };
}
