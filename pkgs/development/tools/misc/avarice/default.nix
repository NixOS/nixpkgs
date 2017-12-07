{ stdenv, fetchurl, pkgconfig, gcc, perl, libusb }:

stdenv.mkDerivation rec {

  name="avarice-2.13";

  src = fetchurl {
    url = "mirror://sourceforge/avarice/${name}.tar.bz2";
    sha256 = "0jhh1h1k5b41v2ycq8kn43nkrkh0b9l7xjmw38rak871g3z3hix1";
  };

  buildInputs = [ pkgconfig gcc perl libusb ];

  meta = {
    license = stdenv.lib.licenses.gpl2;
    description = "Translator between GDB's remote debug protocol and the AVR JTAG ICE protocol";
    homepage = https://sourceforge.net/projects/avarice/files/avarice/;
    maintainers = [ stdenv.lib.maintainers.smironov ];
    platforms = stdenv.lib.platforms.linux;
  };
}

