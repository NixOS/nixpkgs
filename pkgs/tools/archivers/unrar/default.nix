{stdenv, fetchurl}:

let
  version = "5.1.2";
in
stdenv.mkDerivation {
  name = "unrar-${version}";

  src = fetchurl {
    url = "http://www.rarlab.com/rar/unrarsrc-${version}.tar.gz";
    sha256 = "0344cn4w3lw2111m3g431khiyndx9ibbp952bli1inx2fixps9cq";
  };

  patchPhase = ''
    sed -i \
      -e "/CXX=/d" \
      -e "/CXXFLAGS=/d" \
      makefile
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp unrar $out/bin
  '';

  meta = {
    description = "Utility for RAR archives";
    license = "freeware";
    maintainers = [ stdenv.lib.maintainers.emery ];
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin; # arbitrary
  };
}
