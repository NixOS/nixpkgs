{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "which-2.16";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/which-2.16.tar.gz;
    md5 = "830b83af48347a9a3520f561e47cbc9b";
  };
}



