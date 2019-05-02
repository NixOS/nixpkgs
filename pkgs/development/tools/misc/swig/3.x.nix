{ stdenv, fetchFromGitHub, autoconf, automake, libtool, bison, pcre, buildPackages }:

stdenv.mkDerivation rec {
  name = "swig-${version}";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "swig";
    repo = "swig";
    rev = "rel-${version}";
    sha256 = "0yx33972jd3214xr3mrap0j5clma9bvs42qz8x38dfz62xlsi78v";
  };

  PCRE_CONFIG = "${pcre.dev}/bin/pcre-config";
  nativeBuildInputs = [ autoconf automake libtool bison ];
  buildInputs = [ pcre ];

  configureFlags = [ "--without-tcl" ];

  postPatch = ''
    # Disable ccache documentation as it need yodl
    sed -i '/man1/d' CCache/Makefile.in
  '';

  preConfigure = ''
    ./autogen.sh
  '';

  meta = with stdenv.lib; {
    description = "SWIG, an interface compiler that connects C/C++ code to higher-level languages";
    homepage = http://swig.org/;
    # Different types of licenses available: http://www.swig.org/Release/LICENSE .
    license = licenses.gpl3Plus;
    platforms = with platforms; linux ++ darwin;
  };
}
