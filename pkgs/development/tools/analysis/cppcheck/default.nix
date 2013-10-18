{ stdenv, fetchurl }:

# TODO: add support for "make man"

let
  name = "cppcheck";
  version = "1.53";
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${name}/${name}-${version}.tar.bz2";
    sha256 = "878db83d3954d0c45135362308da951ec0670a160c76a7410466a9b539e8677f";
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
