{ stdenv, autoconf, automake, intltool, libtool, fetchFromGitHub, readline }:

stdenv.mkDerivation rec {
  version = "0.15.2";
  name = "scanmem-${version}";
  src = fetchFromGitHub {
    owner  = "scanmem";
    repo   = "scanmem";
    rev    = "v${version}";
    sha256 = "0f93ac5rycf46q60flab5nl7ksadjls13axijg5j5wy1yif0k094";
  };
  buildInputs = [ autoconf automake intltool libtool readline ];
  preConfigure = ''
    ./autogen.sh
  '';
  meta = {
    homepage = "https://github.com/scanmem/scanmem";
    description = "Memory scanner for finding and poking addresses in executing processes";
    maintainers = [ stdenv.lib.maintainers.chattered  ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl3;
  };
}
