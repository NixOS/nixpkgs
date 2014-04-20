{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "dosfstools-3.0.26";

  src = fetchurl {
    url = "http://daniel-baumann.ch/files/software/dosfstools/${name}.tar.xz";
    sha256 = "0x9yi6s1419k678pr9h3a5bjccbrcxxpzmjwgl262ffrikz45126";
  };

  makeFlags = "PREFIX=$(out)";

  meta = {
    description = "Utilities for creating and checking FAT and VFAT file systems";
    repositories.git = git://daniel-baumann.ch/git/software/dosfstools.git;
    homepage = http://www.daniel-baumann.ch/software/dosfstools/;
    platforms = stdenv.lib.platforms.linux;
  };
}
