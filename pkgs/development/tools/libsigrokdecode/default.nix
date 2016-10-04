{ stdenv, fetchurl, pkgconfig, glib, python3, libsigrok, check }:

stdenv.mkDerivation rec {
  name = "libsigrokdecode-0.4.0";

  src = fetchurl {
    url = "http://sigrok.org/download/source/libsigrokdecode/${name}.tar.gz";
    sha256 = "0drmxjc2xavccjl2i6vcjipijrn7459nv8cpmm788pi4fcdrszpx";
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
