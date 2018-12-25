{ stdenv, fetchurl, autoreconfHook, pkgconfig, libxcomp }:

stdenv.mkDerivation rec {
  name = "nxproxy-${version}";
  version = "3.5.99.17-1";

  src = fetchurl {
    sha256 = "18a7cvjnaf50lf1cc5axx9jmi8n9g75d2i5y4s6q9r3phpwyp918";
    url = "https://code.x2go.org/releases/source/nx-libs/nx-libs-${version}-lite.tar.gz";
  };

  buildInputs = [ libxcomp ];
  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  preAutoreconf = ''
    cd nxproxy/
    sed -i 's|-L\$(top_srcdir)/../nxcomp/src/.libs ||' src/Makefile.am
  '';

  makeFlags = [ "exec_prefix=$(out)" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "NX compression proxy";
    homepage = http://wiki.x2go.org/doku.php/wiki:libs:nx-libs;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
