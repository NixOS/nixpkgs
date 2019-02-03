{ stdenv, autoconf, automake, pkgconfig, gettext, libtool, bison
, flex, which, subversion, fetchsvn, makeWrapper, libftdi, libusb, readline
, python3
, svfSupport ? true
, bsdlSupport ? true
, staplSupport ? true
, jedecSupport ? true
}:

stdenv.mkDerivation rec {
  version = "0.10";
  name = "urjtag-${version}";

  src = fetchsvn {
    url = "svn://svn.code.sf.net/p/urjtag/svn/trunk/urjtag";
    rev = "2051";
    sha256 = "0pyl0y27136nr8mmjdml7zjnfnpbjmgqzkjk99j3hvj38k10wq7f";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gettext autoconf automake libtool bison flex which
    subversion makeWrapper readline libftdi libusb python3 ];

  configureFlags = [
    (stdenv.lib.enableFeature svfSupport   "svf")
    (stdenv.lib.enableFeature bsdlSupport  "bsdl")
    (stdenv.lib.enableFeature staplSupport "stapl")
    (stdenv.lib.enableFeature jedecSupport "jedec-exp")
  ];

  preConfigure = "./autogen.sh";

  meta = {
    description = "Enhanced, modern tool for communicating over JTAG with flash chips, CPUs,and many more";
    homepage = http://urjtag.org/;
    license = with stdenv.lib.licenses; [ gpl2Plus lgpl21Plus ];
    platforms = stdenv.lib.platforms.gnu ++ stdenv.lib.platforms.linux;  # arbitrary choice
    maintainers = with stdenv.lib.maintainers; [ lowfatcomputing ];
  };
}

