{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "1.2.2";
  pname = "htpdate";

  src = fetchurl {
    url = "http://www.vervest.org/htp/archive/c/${pname}-${version}.tar.xz";
    sha256 = "0mgr350qwgzrdrwkb9kaj6z7l6hn6a2pwh7sacqvnal5fyc9a7sz";
  };

  makeFlags = [
    "INSTALL=install"
    "STRIP=${stdenv.cc.bintools.targetPrefix}strip"
    "prefix=$(out)"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Utility to fetch time and set the system clock over HTTP";
    homepage = "http://www.vervest.org/htp/";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
}
