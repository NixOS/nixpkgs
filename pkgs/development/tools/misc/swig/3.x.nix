{ lib, stdenv, fetchFromGitHub, autoreconfHook, bison, pcre }:

stdenv.mkDerivation rec {
  name = "swig-${version}";
  version = "3.0.12";

  src = fetchFromGitHub {
    owner = "swig";
    repo = "swig";
    rev = "rel-${version}";
    sha256 = "1wyffskbkzj5zyhjnnpip80xzsjcr3p0q5486z3wdwabnysnhn8n";
  };

  nativeBuildInputs = [ autoreconfHook bison pcre.dev ];
  buildInputs = [ pcre ];

  configureFlags = "--without-tcl --with-pcre=${lib.getLib pcre}";

  postPatch = ''
    # Disable ccache documentation as it need yodl
    sed -i '/man1/d' CCache/Makefile.in
  '';

  autoreconfPhase = '' ./autogen.sh '';

  meta = with stdenv.lib; {
    description = "SWIG, an interface compiler that connects C/C++ code to higher-level languages";
    homepage = http://swig.org/;
    # Different types of licenses available: http://www.swig.org/Release/LICENSE .
    license = licenses.gpl3Plus;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ wkennington ];
  };
}
