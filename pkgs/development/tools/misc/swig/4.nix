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
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "swig";
    repo = "swig";
    rev = "rel-${version}";
    sha256 = "12vlps766xvwck8q0i280s8yx21qm2dxl34710ybpmz3c1cfdjsc";
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
    description = "SWIG, an interface compiler that connects C/C++ code to higher-level languages";
    homepage = "https://swig.org/";
    # Different types of licenses available: http://www.swig.org/Release/LICENSE .
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ orivej ];
    platforms = with platforms; linux ++ darwin;
  };
}
