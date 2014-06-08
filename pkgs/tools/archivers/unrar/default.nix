{stdenv, fetchurl}:

let
  version = "5.1.5";
in
stdenv.mkDerivation {
  name = "unrar-${version}";

  src = fetchurl {
    url = "http://www.rarlab.com/rar/unrarsrc-${version}.tar.gz";
    sha256 = "1jrla255911rbl953br2xbgvyw15kpi11r4lpqm3jlw553ccw912";
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
