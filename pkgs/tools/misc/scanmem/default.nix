{ stdenv, autoconf, automake, intltool, libtool, fetchFromGitHub, readline }:

stdenv.mkDerivation rec {
  version = "0.16";
  name = "scanmem-${version}";
 
  src = fetchFromGitHub {
    owner  = "scanmem";
    repo   = "scanmem";
    rev    = "v${version}";
    sha256 = "131rx6cpnlz2x36r0ry80gqapmxpz2qc3h0040xhvp7ydmd4fyjd";
  };

  nativeBuildInputs = [ autoconf automake intltool libtool ];
  buildInputs = [ readline ];
  
  preConfigure = ''
    ./autogen.sh
  '';
  meta = with stdenv.lib; {
    homepage = "https://github.com/scanmem/scanmem";
    description = "Memory scanner for finding and poking addresses in executing processes";
    maintainers = [ maintainers.chattered  ];
    platforms = with platforms; linux ++ darwin;
    license = licenses.gpl3;
  };
}
