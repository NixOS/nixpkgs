{ stdenv, fetchurl }:

# TODO: add support for "make man"

let
  name = "cppcheck";
  version = "1.63";
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${name}/${name}-${version}.tar.bz2";
    sha256 = "0r10z44qydqxxxlxiggl2nzksd3gkb7bp784dfmpnnr1jd2zqjwj";
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
