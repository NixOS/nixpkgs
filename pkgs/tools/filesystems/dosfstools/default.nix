{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "dosfstools-3.0.21";

  src = fetchurl {
    url = "http://daniel-baumann.ch/files/software/dosfstools/${name}.tar.xz";
    sha256 = "12c9ilcpknm7hg3czkc50azndd0yjdj4jjnvizhwqxy3g0gm2960";
  };

  makeFlags = "PREFIX=$(out)";

  meta = {
    description = "Utilities for creating and checking FAT and VFAT file systems";
    homepage = http://www.daniel-baumann.ch/software/dosfstools/;
    platforms = stdenv.lib.platforms.linux;
  };
}
