{stdenv, fetchurl, patch}:

derivation {
  name = "util-linux-2.12";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://ftp.cwi.nl/aeb/util-linux/util-linux-2.12.tar.gz;
    md5 = "997adf78b98d9d1c5db4f37ea982acff";
  };
  mconfigPatch = ./MCONFIG.patch;
  inherit stdenv patch;
}
