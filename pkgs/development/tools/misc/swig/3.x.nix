{ lib, stdenv, fetchFromGitHub, autoconf, automake, libtool, bison, pcre }:

stdenv.mkDerivation rec {
  name = "swig-${version}";
  version = "3.0.10";

  src = fetchFromGitHub {
    owner = "swig";
    repo = "swig";
    rev = "rel-${version}";
    sha256 = "049rj883r9mf2bgabj3b03p7cnmqgl5939lmh8v5nnia24zb51jg";
  };

  nativeBuildInputs = [ autoconf automake libtool bison ];
  buildInputs = [ pcre ];

  configureFlags = "--without-tcl";

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
    maintainers = with maintainers; [ wkennington ];
  };
}
