{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "dosfstools-3.09";

  src = fetchurl {
    url = http://www.daniel-baumann.ch/software/dosfstools/dosfstools-3.0.1.tar.bz2;
    sha256 = "7fab0de42391277028071d01ff4da83ff9a399408ccf29958cdee62ffe746d45";
  };

  makeFlags = "PREFIX=$(out)";

  meta = {
    description = "Utilities for creating and checking FAT and VFAT file systems";
    homepage = http://www.daniel-baumann.ch/software/dosfstools/;
  };
}
