{ stdenv, fetchurl, coreutils, binutils }:

stdenv.mkDerivation rec {
  version = "1.1.3";
  name = "htpdate-${version}";

  src = fetchurl {
    url = "http://twekkel.home.xs4all.nl/htp/htpdate-${version}.tar.gz";
    sha256 = "0hfg4qrsmpqw03m9qwf3zgi4brbf65w6wd3w30nkamc7x8b4vn5i";
  };

  installFlags = [
    "INSTALL=${coreutils}/bin/install"
    "STRIP=${binutils}/bin/strip"
    "prefix=$(out)"
  ];

  meta = {
    description = "Utility to fetch time and set the system clock over HTTP";
    homepage = http://www.vervest.org/htp/;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
