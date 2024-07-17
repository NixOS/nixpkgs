{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  libtool,
  bison,
  pcre,
}:

stdenv.mkDerivation rec {
  pname = "swig";
  version = "3.0.12";

  src = fetchFromGitHub {
    owner = "swig";
    repo = "swig";
    rev = "rel-${version}";
    sha256 = "1wyffskbkzj5zyhjnnpip80xzsjcr3p0q5486z3wdwabnysnhn8n";
  };

  PCRE_CONFIG = "${pcre.dev}/bin/pcre-config";
  nativeBuildInputs = [
    autoconf
    automake
    libtool
    bison
  ];
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
    description = "Interface compiler that connects C/C++ code to higher-level languages";
    homepage = "https://swig.org/";
    # Different types of licenses available: http://www.swig.org/Release/LICENSE .
    license = licenses.gpl3Plus;
    platforms = with platforms; linux ++ darwin;
  };
}
