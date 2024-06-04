{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "netcat-gnu";
  version = "0.7.1";

  src = fetchurl {
    url = "mirror://sourceforge/netcat/netcat-${version}.tar.bz2";
    sha256 = "1frjcdkhkpzk0f84hx6hmw5l0ynpmji8vcbaxg8h5k2svyxz0nmm";
  };

  meta = with lib; {
    description = "Utility which reads and writes data across network connections";
    homepage = "https://netcat.sourceforge.net/";
    mainProgram = "netcat";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
