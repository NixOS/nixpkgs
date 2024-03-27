{ lib, stdenv, fetchFromGitHub, autoconf, automake, libtool, bison, pcre2 }:

stdenv.mkDerivation rec {
  pname = "swig";
  version = "4.2.1";

  src = fetchFromGitHub {
    owner = "swig";
    repo = "swig";
    rev = "v${version}";
    hash = "sha256-iJWHi5IVYS5zYRID3I9SMsYm5NB//EUyki83VRjwZ8o=";
  };

  PCRE_CONFIG = "${pcre2.dev}/bin/pcre-config";
  nativeBuildInputs = [ autoconf automake libtool bison ];
  buildInputs = [ pcre2 ];

  configureFlags = [ "--without-tcl" ];

  # Disable ccache documentation as it needs yodl
  postPatch = ''
    sed -i '/man1/d' CCache/Makefile.in
  '';

  preConfigure = ''
    ./autogen.sh
  '';

  meta = with lib; {
    description = "Interface compiler that connects C/C++ code to higher-level languages";
    homepage = "https://swig.org/";
    # Different types of licenses available: https://www.swig.org/Release/LICENSE .
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ orivej ];
    platforms = with platforms; linux ++ darwin;
  };
}
