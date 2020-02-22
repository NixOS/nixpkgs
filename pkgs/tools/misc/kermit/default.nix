{ stdenv, fetchurl, ncurses, glibc }:

stdenv.mkDerivation {
  name = "kermit-9.0.302";

  src = fetchurl {
    url = ftp://ftp.kermitproject.org/kermit/archives/cku302.tar.gz;
    sha256 = "0487mh6s99ijqf1pfmbm302pa5i4pzmm8s439hdl1ffs5g8jqpqd";
  };

  buildInputs = [ ncurses glibc ];

  unpackPhase = ''
    mkdir -p src
    pushd src
    tar xvzf $src
  '';

  patchPhase = ''
    sed -i -e 's@-I/usr/include/ncurses@@' \
      -e 's@/usr/local@'"$out"@ makefile
  '';

  buildPhase = "make -f makefile linux LNKFLAGS='-lcrypt -lresolv'";

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/man/man1
    make -f makefile install
  '';

  meta = with stdenv.lib; {
    homepage = http://www.kermitproject.org/ck90.html;
    description = "Portable Scriptable Network and Serial Communication Software";
    license = licenses.bsd3;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; linux;
    broken = true;
  };
}
