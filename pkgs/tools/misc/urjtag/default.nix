{ stdenv, autoconf, automake, pkgconfig, gettext, intltool, libtool, bison
, flex, fetchgit, makeWrapper
, jedecSupport ? false
, pythonBindings ? false
, python3 ? null
}:

stdenv.mkDerivation rec {
  version = "0.10";
  name = "urjtag-${version}";

  src = fetchgit {
    url = "git://git.code.sf.net/p/urjtag/git";
    rev = "7ba12da7845af7601e014a2a107670edc5d6997d";
    sha256 = "834401d851728c48f1c055d24dc83b6173c701bf352d3a964ec7ff1aff3abf6a";
  };

  buildInputs = [ gettext pkgconfig autoconf automake libtool makeWrapper ]
    ++ stdenv.lib.optional pythonBindings python3;

  configureFlags = ''
    --prefix=/
    ${if jedecSupport then "--enable-jedec-exp" else "--disable-jedec-exp"}
    ${if pythonBindings then "--enable-python" else "--disable-python"}
  '';
  preConfigure = "cd urjtag; ./autogen.sh";

  makeFlags = [ "DESTDIR=$(out)" ];

  meta = {
    description = "Enhanced, modern tool for communicating over JTAG with flash chips, CPUs,and many more";
    homepage = "http://urjtag.org/";
    license = with stdenv.lib.licenses; [ gpl2Plus lgpl21Plus ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
    maintainers = with stdenv.lib.maintainers; [ lowfatcomputing ];
  };
}

