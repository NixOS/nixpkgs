{ lib, stdenv, fetchFromGitHub, autoconf, automake, libtool, bison, pcre }:

stdenv.mkDerivation rec {
  pname = "swig";
  version = "2.0.12";

  src = fetchFromGitHub {
    owner = "swig";
    repo = "swig";
    rev = "rel-${version}";
    sha256 = "0khm9gh5pczfcihr0pbicaicc4v9kjm5ip2alvkhmbb3ga6njkcm";
  };

  # pcre-config isn't on PATH when cross-building
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

  meta = with lib; {
    description = "SWIG, an interface compiler that connects C/C++ code to higher-level languages";
    homepage = "https://swig.org/";
    # Different types of licenses available: http://www.swig.org/Release/LICENSE .
    license = licenses.gpl3Plus;
    platforms = with platforms; linux ++ darwin;
  };
}
