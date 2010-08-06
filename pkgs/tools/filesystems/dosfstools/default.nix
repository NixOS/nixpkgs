{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "dosfstools-3.0.9";

  src = fetchurl {
    url = "http://www.daniel-baumann.ch/software/dosfstools/${name}.tar.bz2";
    sha256 = "13s5s0hvhmn7r4ppqmw8nqgdm5v5vc6r5j44kn87wl5cmrpnfqrz";
  };

  makeFlags = "PREFIX=$(out)";

  meta = {
    description = "Utilities for creating and checking FAT and VFAT file systems";
    homepage = http://www.daniel-baumann.ch/software/dosfstools/;
    platforms = stdenv.lib.platforms.linux;
  };
}
