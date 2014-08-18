{stdenv, fetchurl, perl}:

stdenv.mkDerivation {
  name = "halibut-1.0";

  src = fetchurl {
    url = http://www.chiark.greenend.org.uk/~sgtatham/halibut/halibut-1.0.tar.gz;
    sha256 = "0d039adb88cb8de6f350563514d013209c2d321d1e5c49ea56462c6803f29adb";
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

  meta = {
    description = "Documentation production system for software manuals";
    homepage = http://www.chiark.greenend.org.uk/~sgtatham/halibut/;
    license = "free";
  };
}
