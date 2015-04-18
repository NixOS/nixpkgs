{ stdenv, fetchurl }:

# TODO: add support for "make man"

let
  name = "cppcheck";
  version = "1.68";
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${name}/${name}-${version}.tar.bz2";
    sha256 = "1ca9fdhrrxfyzd6kn67gxbfszp70191cf3ndasrh5jh55ghybmmd";
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
