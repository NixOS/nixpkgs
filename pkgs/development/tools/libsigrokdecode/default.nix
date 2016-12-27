{ stdenv, fetchurl, pkgconfig, glib, python3, libsigrok, check }:

stdenv.mkDerivation rec {
  name = "libsigrokdecode-0.4.1";

  src = fetchurl {
    url = "http://sigrok.org/download/source/libsigrokdecode/${name}.tar.gz";
    sha256 = "15aabl9p4586v2bkj4bm4xi7l3309r9zb31sw233s5vi170p0pq6";
  };

  buildInputs = [ pkgconfig glib python3 libsigrok check ];

  meta = with stdenv.lib; {
    description = "Protocol decoding library for the sigrok signal analysis software suite";
    homepage = http://sigrok.org/;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
