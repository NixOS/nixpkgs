{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "dosfstools-3.0.24";

  src = fetchurl {
    url = "http://daniel-baumann.ch/files/software/dosfstools/${name}.tar.xz";
    sha256 = "1hblhb98wm9gm60y32psdqm5jprs4a6dqzrapzgb6bw7r3kvf88y";
  };

  makeFlags = "PREFIX=$(out)";

  meta = {
    description = "Utilities for creating and checking FAT and VFAT file systems";
    homepage = http://www.daniel-baumann.ch/software/dosfstools/;
    platforms = stdenv.lib.platforms.linux;
  };
}
