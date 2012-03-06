{stdenv, fetchurl, ncurses}:
stdenv.mkDerivation {
  name = "kermit-8.0.211";

  src = fetchurl {
    url = ftp://kermit.columbia.edu/kermit/archives/cku211.tar.gz;
    sha256 = "14xsmdlsk2pgsp51l7lxwncgljwvgm446a4m6nk488shj94cvrrr";
  };

  buildInputs = [ ncurses ];

  unpackPhase = ''
    mkdir -p src
    pushd src
    tar xvzf $src
  '';

  patchPhase = ''
    sed -i -e 's@-I/usr/include/ncurses@@' \
      -e 's@-lncurses@-lncurses -lresolv -lcrypt@' \
      -e 's@/usr/local@'"$out"@ makefile
  '';
  buildPhase = "make -f makefile linux";
  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/man/man1
    make -f makefile install
  '';

  meta = {
    homepage = "http://www.columbia.edu/kermit/ck80.html";
    description = "Portable Scriptable Network and Serial Communication Software";
    license = "free";
  };
}
