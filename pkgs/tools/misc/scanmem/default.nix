{ stdenv, autoconf, automake, intltool, libtool, fetchFromGitHub, readline }:

stdenv.mkDerivation rec {
  version = "0.15.6";
  name = "scanmem-${version}";
  src = fetchFromGitHub {
    owner  = "scanmem";
    repo   = "scanmem";
    rev    = "v${version}";
    sha256 = "16cw76ji3mp0sj8q0sz5wndavk10n0si1sm6kr5zpiws4sw047ii";
  };
  buildInputs = [ autoconf automake intltool libtool readline ];
  preConfigure = ''
    ./autogen.sh
  '';
  meta = {
    homepage = "https://github.com/scanmem/scanmem";
    description = "Memory scanner for finding and poking addresses in executing processes";
    maintainers = [ stdenv.lib.maintainers.chattered  ];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
    license = stdenv.lib.licenses.gpl3;
  };
}
