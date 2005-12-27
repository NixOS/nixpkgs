{stdenv, fetchurl, coreutils ? null, dietgcc}:

stdenv.mkDerivation {
  name = "diffutils-2.8.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/diffutils-2.8.1.tar.gz;
    md5 = "71f9c5ae19b60608f6c7f162da86a428";
  };
  /* If no explicit coreutils is given, use the one from stdenv. */
  inherit coreutils;
  NIX_GCC=dietgcc;
}
