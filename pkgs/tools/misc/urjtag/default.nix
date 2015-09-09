{ stdenv, autoconf, automake, pkgconfig, gettext, intltool, libtool, bison
, flex, which, subversion, fetchsvn, makeWrapper
, jedecSupport ? false
, pythonBindings ? false
, python3 ? null
}:

stdenv.mkDerivation rec {
  version = "0.10";
  name = "urjtag-${version}";

  src = fetchsvn {
    url = "svn://svn.code.sf.net/p/urjtag/svn/trunk/urjtag";
    rev = "2051";
    sha256 = "0pyl0y27136nr8mmjdml7zjnfnpbjmgqzkjk99j3hvj38k10wq7f";
  };

  buildInputs = [ gettext pkgconfig autoconf automake libtool bison flex which subversion makeWrapper ]
    ++ stdenv.lib.optional pythonBindings python3;

  configureFlags = ''
    ${if jedecSupport then "--enable-jedec-exp" else "--disable-jedec-exp"}
    ${if pythonBindings then "--enable-python" else "--disable-python"}
  '';

  preConfigure = "./autogen.sh";

  meta = {
    description = "Enhanced, modern tool for communicating over JTAG with flash chips, CPUs,and many more";
    homepage = "http://urjtag.org/";
    license = with stdenv.lib.licenses; [ gpl2Plus lgpl21Plus ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
    maintainers = with stdenv.lib.maintainers; [ lowfatcomputing ];
  };
}

