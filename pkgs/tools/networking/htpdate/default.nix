{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "1.2.0";
  name = "htpdate-${version}";

  src = fetchurl {
    url = "http://www.vervest.org/htp/archive/c/${name}.tar.xz";
    sha256 = "00xwppq3aj951m0srjvxmr17kiaaflyjmbfkvpnfs3jvqhzczci2";
  };

  makeFlags = [
    "INSTALL=install"
    "STRIP=${stdenv.cc.bintools.prefix}strip"
    "prefix=$(out)"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Utility to fetch time and set the system clock over HTTP";
    homepage = http://www.vervest.org/htp/;
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
  };
}
