{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "util-linux-2.12";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/util-linux-2.12.tar.gz;
    md5 = "997adf78b98d9d1c5db4f37ea982acff";
  };
  mconfigPatch = ./MCONFIG.patch;
}
