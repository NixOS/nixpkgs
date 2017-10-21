{ stdenv, fetchurl, autoreconfHook, libxcomp }:

stdenv.mkDerivation rec {
  name = "nxproxy-${version}";
  version = "3.5.0.32";

  src = fetchurl {
    sha256 = "02n5bdc1jsq999agb4w6dmdj5l2wlln2lka84qz6rpswwc59zaxm";
    url = "http://code.x2go.org/releases/source/nx-libs/nx-libs-${version}-lite.tar.gz";
  };

  buildInputs = [ libxcomp ];
  nativeBuildInputs = [ autoreconfHook ];

  preAutoreconf = ''
    cd nxproxy/
  '';

  makeFlags = [ "exec_prefix=$(out)" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "NX compression proxy";
    homepage = http://wiki.x2go.org/doku.php/wiki:libs:nx-libs;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
