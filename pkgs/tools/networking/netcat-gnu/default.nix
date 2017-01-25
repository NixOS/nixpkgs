{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "netcat-gnu-0.7.1";

  src = fetchurl {
    url = mirror://sourceforge/netcat/netcat-0.7.1.tar.bz2;
    sha256 = "1frjcdkhkpzk0f84hx6hmw5l0ynpmji8vcbaxg8h5k2svyxz0nmm";
  };

  meta = with stdenv.lib; {
    description = "Utility which reads and writes data across network connections";
    homepage = http://netcat.sourceforge.net/;
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
