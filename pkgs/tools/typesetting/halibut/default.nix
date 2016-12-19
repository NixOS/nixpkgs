{stdenv, fetchurl, perl}:

stdenv.mkDerivation rec {
  name = "halibut-1.1";

  src = fetchurl {
    url = "http://www.chiark.greenend.org.uk/~sgtatham/halibut/${name}.tar.gz";
    sha256 = "18409ir55rsa5gkizw2hsr86wgv176jms2dc52px62gd246rar5r";
  };

  buildInputs = [ perl ];

  patchPhase = ''
    sed -i -e s@/usr/local@$out@ Makefile
    sed -i -e 's@(prefix)/man@(prefix)/share/man@' doc/Makefile
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1
    pushd doc
    make halibut.1
    popd
    make install
  '';

  meta = with stdenv.lib; {
    description = "Documentation production system for software manuals";
    homepage = http://www.chiark.greenend.org.uk/~sgtatham/halibut/;
    license = licenses.mit;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; unix;
  };
}
