{stdenv, fetchurl, patch}:

stdenv.mkDerivation {
  name = "sysvinit-2.85";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.cistron.nl/pub/people/miquels/sysvinit/sysvinit-2.85.tar.gz;
    md5 = "8a2d8f1ed5a2909da04132fefa44905e";
  };
  srcPatch = ./patch;
  inherit patch;
}
