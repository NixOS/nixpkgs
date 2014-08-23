{ stdenv, fetchurl }:

# TODO: add support for "make man"

let
  name = "cppcheck";
  version = "1.65";
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${name}/${name}-${version}.tar.bz2";
    sha256 = "0rsxnqvjyiviqsq4y5x4p1jpvcmhf8hh7d710rsvnv5d4cj7lmqn";
  };

  configurePhase = ''
    makeFlags="PREFIX=$out CFGDIR=$out/cfg"
  '';

  postInstall = "cp -r cfg $out/cfg";

  meta = {
    description = "Check C/C++ code for memory leaks, mismatching allocation-deallocation, buffer overrun and more";
    homepage = "http://sourceforge.net/apps/mediawiki/cppcheck/";
    license = "GPL";
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
