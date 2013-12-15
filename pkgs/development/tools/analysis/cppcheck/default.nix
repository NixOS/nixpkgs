{ stdenv, fetchurl }:

# TODO: add support for "make man"

let
  name = "cppcheck";
  version = "1.62";
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${name}/${name}-${version}.tar.bz2";
    sha256 = "031x2khbk0anlacpdk5g5r3q3y4xj0z5zsfhf2wcv189hxl7698c";
  };

  configurePhase = "makeFlags=PREFIX=$out";

  meta = {
    description = "Check C/C++ code for memory leaks, mismatching allocation-deallocation, buffer overrun and more";
    homepage = "http://sourceforge.net/apps/mediawiki/cppcheck/";
    license = "GPL";
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
