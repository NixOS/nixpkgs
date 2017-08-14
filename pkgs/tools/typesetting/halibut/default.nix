{stdenv, fetchurl, perl}:

stdenv.mkDerivation rec {
  name = "halibut-1.2";

  src = fetchurl {
    url = "http://ww.chiark.greenend.org.uk/~sgtatham/halibut/${name}/${name}.tar.gz";
    sha256 = "0gqnhfqf555rfpk5xj1imbdxnbkkrv4wl3rrdb1r0wgj81igpv8s";
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
    homepage = https://www.chiark.greenend.org.uk/~sgtatham/halibut/;
    license = licenses.mit;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; unix;
  };
}
