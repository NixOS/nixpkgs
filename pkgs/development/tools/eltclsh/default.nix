{ lib
, stdenv
, fetchgit
, automake
, autoconf
, libtool
, libedit
, tcl
, tk
}:

tcl.mkTclDerivation rec {
  pname = "eltclsh";
  version = "1.18";

  src = fetchgit {
    url = "https://git.openrobots.org/robots/eltclsh.git";
    rev = "eltclsh-${version}";
    hash = "sha256-C996BJxEoCSpA0x/nSnz4nnmleTIWyzm0imZp/K+Q/o=";
  };

  nativeBuildInputs = [
    automake
    autoconf
    libtool
  ];
  buildInputs = [
    libedit
    tk
  ];

  preConfigure = "NOCONFIGURE=1 ./autogen.sh";

  configureFlags = [
    "--enable-tclshrl"
    "--enable-wishrl"
    "--with-tk=${tk}/lib"
    "--with-includes=${libedit.dev}/include/readline"
    "--with-libtool=${libtool}"
  ];

  meta = with lib; {
    description = "Interactive shell for the TCL programming language based on editline";
    homepage = "https://homepages.laas.fr/mallet/soft/shell/eltclsh";
    license = licenses.bsd3;
    maintainers = with maintainers; [ iwanb ];
    platforms = platforms.all;
  };
}
