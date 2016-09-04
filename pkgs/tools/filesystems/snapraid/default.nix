{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "snapraid-${version}";
  version = "8.1";

  src = fetchurl {
    url = "https://github.com/amadvance/snapraid/releases/download/v${version}/snapraid-${version}.tar.gz";
    sha256 = "0pafqn9ismn4j3fsx8fgf008qwh2c6f8mjfjijah6d5c349rmy3b";
  };

  meta = {
    homepage = http://www.snapraid.it/;
    description = "A backup program for disk arrays";
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.makefu ];
    platforms = stdenv.lib.platforms.unix;
  };
}
