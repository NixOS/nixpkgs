{ stdenv, fetchgit, cmake, boehmgc, expat, cppunit }:

stdenv.mkDerivation {
  name = "boomerang-1.0pre";

  buildInputs = [ cmake boehmgc expat cppunit ];

  installPhase = ''
    for loaderfile in loader/*.so
    do
      install -vD "$loaderfile" "$out/lib/$(basename "$loaderfile")"
    done

    install -vD boomerang "$out/bin/boomerang"
  '';

  src = fetchgit {
    url = "git://github.com/aszlig/boomerang.git";
    rev = "d0b147a5dfc915a5fa8fe6c517e66a049a37bf22";
    sha256 = "6cfd95a3539ff45c18b17de76407568b0d0c17fde4e45dda54486c7eac113969";
  };

  meta = {
    homepage = http://boomerang.sourceforge.net/;
    license = stdenv.lib.licenses.bsd3;
    description = "A general, open source, retargetable decompiler";
  };
}
