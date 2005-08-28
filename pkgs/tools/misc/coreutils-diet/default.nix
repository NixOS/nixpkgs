{stdenv, fetchurl, dietgcc, perl}:

stdenv.mkDerivation {
  name = "coreutils-5.2.1";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/coreutils-5.2.1.tar.bz2;
    md5 = "172ee3c315af93d3385ddfbeb843c53f";
  };
  patches = [./coreutils-dummy.patch];
  buildInputs = [perl];
  NIX_GCC = dietgcc;
  NIX_GLIBC_FLAGS_SET=1;
  NIX_CFLAGS_COMPILE="-D_BSD_SOURCE=1";
}
