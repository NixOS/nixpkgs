{ stdenv, fetchurl, autoreconfHook, pkgconfig, libxcomp }:

stdenv.mkDerivation rec {
  name = "nxproxy-${version}";
  version = "3.5.99.16";

  src = fetchurl {
    sha256 = "1m3z9w3h6qpgk265xf030w7lcs181jgw2cdyzshb7l97mn1f7hh2";
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
