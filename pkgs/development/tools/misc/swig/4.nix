{ stdenv, fetchFromGitHub, autoconf, automake, libtool, bison, pcre }:

stdenv.mkDerivation rec {
  pname = "swig";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "swig";
    repo = "swig";
    rev = "rel-${version}";
    sha256 = "1i1gl5gd6b5i1hiazq7m4nvlq86zd0fhk052xhwlnb596pjhgyhf";
  };

  PCRE_CONFIG = "${pcre.dev}/bin/pcre-config";
  nativeBuildInputs = [ autoconf automake libtool bison ];
  buildInputs = [ pcre ];

  configureFlags = [ "--without-tcl" ];

  # Disable ccache documentation as it needs yodl
  postPatch = ''
    sed -i '/man1/d' CCache/Makefile.in
  '';

  preConfigure = ''
    ./autogen.sh
  '';

  meta = with stdenv.lib; {
    description = "SWIG, an interface compiler that connects C/C++ code to higher-level languages";
    homepage = "http://swig.org/";
    # Different types of licenses available: http://www.swig.org/Release/LICENSE .
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ orivej ];
    platforms = with platforms; linux ++ darwin;
  };
}
