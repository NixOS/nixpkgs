{ stdenv, fetchgit, gcc, gmp, libsigsegv, openssl, automake, autoconf, ragel,
  cmake, re2c, libtool, ncurses, perl, zlib, python }:

stdenv.mkDerivation rec {

  name = "urbit-${version}";
  version = "2015.09.26";

  src = fetchgit {
    url = "https://github.com/urbit/urbit.git";
    rev = "c9592664c797b2dd74f26886528656f8a7058640";
    sha256 = "0sgrxnmpqh54mgar81wlb6gff8c0pc24p53xwxr448g5shvnzjx9";
  };

  buildInputs = with stdenv.lib; [
    gcc gmp libsigsegv openssl automake autoconf ragel cmake re2c libtool
    ncurses perl zlib python
  ];

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
    description = "an operating function";
    homepage = http://urbit.org/preview/~2015.9.25/materials;
    license = licenses.mit;
    maintainers = with maintainers; [ mudri ];
  };
}
