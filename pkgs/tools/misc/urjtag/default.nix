{ stdenv, autoconf, automake, pkgconfig, gettext, libtool, bison
, flex, which, subversion, fetchurl, makeWrapper, libftdi1, libusb-compat-0_1, readline
, python3
, svfSupport ? true
, bsdlSupport ? true
, staplSupport ? true
, jedecSupport ? true
}:

stdenv.mkDerivation rec {
  version = "2019.12";
  pname = "urjtag";

  src = fetchurl {
    url = "https://downloads.sourceforge.net/project/urjtag/urjtag/${version}/urjtag-${version}.tar.xz";
    sha256 = "1k2vmvvarik0q3llbfbk8ad35mcns7w1ln9gla1mn7z9c6x6x90r";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gettext autoconf automake libtool bison flex which
    subversion makeWrapper readline libftdi1 libusb-compat-0_1 python3 ];

  configureFlags = [
    (stdenv.lib.enableFeature svfSupport   "svf")
    (stdenv.lib.enableFeature bsdlSupport  "bsdl")
    (stdenv.lib.enableFeature staplSupport "stapl")
    (stdenv.lib.enableFeature jedecSupport "jedec-exp")
  ];

  meta = {
    description = "Enhanced, modern tool for communicating over JTAG with flash chips, CPUs,and many more";
    homepage = "http://urjtag.org/";
    license = with stdenv.lib.licenses; [ gpl2Plus lgpl21Plus ];
    platforms = stdenv.lib.platforms.gnu ++ stdenv.lib.platforms.linux;  # arbitrary choice
    maintainers = with stdenv.lib.maintainers; [ lowfatcomputing ];
  };
}

