{ stdenv, fetchFromGitHub, gcc, gmp, libsigsegv, openssl, automake, autoconf, ragel,
  cmake, re2c, libtool, ncurses, perl, zlib, python2, curl }:

stdenv.mkDerivation rec {
  name = "urbit-${version}";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "urbit";
    repo = "urbit";
    rev = "v${version}";
    sha256 = "1ndy58ypilabf9pfkqzzl7wf6x1vr4gpvsbn30sygp2ip908q0xz";
  };

  buildInputs = with stdenv.lib; [
    gcc gmp libsigsegv openssl automake autoconf ragel cmake re2c libtool
    ncurses perl zlib python2 curl
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
