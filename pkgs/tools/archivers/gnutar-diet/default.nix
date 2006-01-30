{stdenv, fetchurl, dietgcc}:

stdenv.mkDerivation {
  name = "gnutar-1.15.1";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/tar-1.15.1.tar.bz2;
    md5 = "57da3c38f8e06589699548a34d5a5d07";
  };
  NIX_GCC = dietgcc;
  NIX_GLIBC_FLAGS_SET=1;
  NIX_CFLAGS_COMPILE="-D_BSD_SOURCE=1";
}
