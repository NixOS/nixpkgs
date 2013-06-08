{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "dosfstools-3.0.11";

  src = fetchurl {
    urls = [
      "http://www.daniel-baumann.ch/software/dosfstools/${name}.tar.bz2"
      "http://pkgs.fedoraproject.org/repo/pkgs/dosfstools/${name}.tar.bz2/8d2211d5bd813164e20740e7c852aa06/${name}.tar.bz2"
    ];
    sha256 = "1a6rzjy82f6579ywaln33g1wc7k8gbgjdss9q2q8daplac7pmcll";
  };

  makeFlags = "PREFIX=$(out)";

  meta = {
    description = "Utilities for creating and checking FAT and VFAT file systems";
    homepage = http://www.daniel-baumann.ch/software/dosfstools/;
    platforms = stdenv.lib.platforms.linux;
  };
}
