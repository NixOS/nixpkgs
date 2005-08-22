{stdenv, fetchurl, perl, m4, gcc}:

assert perl != null && m4 != null;

stdenv.mkDerivation {
  name = "uml-2.4.27-1";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/linux-2.4.27.tar.bz2;
    md5 = "59a2e6fde1d110e2ffa20351ac8b4d9e";
  };
  umlPatch = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/uml-patch-2.4.27-1.bz2;
    md5 = "63178bbd3a383a1005738f4628ff583e";
  };
  noAioPatch = ./no-aio.patch;
#  hostfsPatch = ./hostfs.patch;
#  hostfsAccessPatch = ./hostfs-access.patch;
  config = ./config;
  buildInputs = [perl m4];
  NIX_GCC = gcc;
}
