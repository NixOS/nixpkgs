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
    url = "git://github.com/andrew-aladev/boomerang.git";
    rev = "c0ad5c1f64091725b4ca7f63c57edd3d3bc74a57";
    sha256 = "76d8512db672bad1322943172046e4b450c5fa509e4141457b3dc60493852fcc";
  };

  meta = {
    homepage = http://boomerang.sourceforge.net/;
    license = stdenv.lib.licenses.bsd3;
    description = "A general, open source, retargetable decompiler";
  };
}
