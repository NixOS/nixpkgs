{ stdenv, fetchFromGitHub, gcc, gmp, libsigsegv, openssl, automake, autoconf, ragel,
  cmake, re2c, libtool, ncurses, perl, zlib, python }:

stdenv.mkDerivation rec {

  name = "urbit-${version}";
  version = "2016-06-02";

  src = fetchFromGitHub {
    owner = "urbit";
    repo = "urbit";
    rev = "8c113559872e4a97bce3f3ee5b370ad9545c7459";
    sha256 = "055qdpp4gm0v04pddq4380pdsi0gp2ybgv1d2lchkhwsnjyl46jl";
  };

  buildInputs = with stdenv.lib; [
    gcc gmp libsigsegv openssl automake autoconf ragel cmake re2c libtool
    ncurses perl zlib python
  ];

  # uses 'readdir_r' deprecated by glibc 2.24
  NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

  configurePhase = ''
    :
  '';

  buildPhase = ''
    sed -i 's/-lcurses/-lncurses/' Makefile
    mkdir -p $out
    cp -r . $out/
    cd $out
    make
  '';

  installPhase = ''
    :
  '';

  meta = with stdenv.lib; {
    description = "An operating function";
    homepage = http://urbit.org;
    license = licenses.mit;
    maintainers = with maintainers; [ mudri ];
    platforms = with platforms; linux;
  };
}
