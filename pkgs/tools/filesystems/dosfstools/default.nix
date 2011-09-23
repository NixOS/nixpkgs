{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "dosfstools-3.0.11";

  src = fetchurl {
    url = "http://www.daniel-baumann.ch/software/dosfstools/${name}.tar.bz2";
    sha256 = "1a6rzjy82f6579ywaln33g1wc7k8gbgjdss9q2q8daplac7pmcll";
  };

  makeFlags = "PREFIX=$(out)";

  meta = {
    description = "Utilities for creating and checking FAT and VFAT file systems";
    homepage = http://www.daniel-baumann.ch/software/dosfstools/;
    platforms = stdenv.lib.platforms.linux;
  };
}
