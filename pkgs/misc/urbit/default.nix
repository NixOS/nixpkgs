{ stdenv, fetchFromGitHub, gcc, gmp, libsigsegv, openssl, automake, autoconf, ragel,
  cmake, re2c, libtool, ncurses, perl, zlib, python2, curl }:

stdenv.mkDerivation rec {

  name = "urbit-${version}";
  version = "2016-11-01";

  src = fetchFromGitHub {
    owner = "urbit";
    repo = "urbit";
    rev = "83a74d475772b623c81f06fa46af675d121b6263";
    sha256 = "0hs87ilmdjwi0jjl38nga1kvc2kzfyvf999hcwx5qan8ds1qlp2a";
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
