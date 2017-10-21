{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "dog-1.7";

  src = fetchurl {
    url = "http://archive.debian.org/debian/pool/main/d/dog/dog_1.7.orig.tar.gz";
    sha256 = "3ef25907ec5d1dfb0df94c9388c020b593fbe162d7aaa9bd08f35d2a125af056";
  };

  patchPhase = ''
    substituteInPlace Makefile \
      --replace "gcc" "cc"
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/man/man1
    cp dog.1 $out/man/man1
    cp dog $out/bin
  '';

  meta = with stdenv.lib; {
    homepage = http://lwn.net/Articles/421072/;
    description = "cat replacement";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ qknight ];
    platforms = platforms.all;
  };
}
