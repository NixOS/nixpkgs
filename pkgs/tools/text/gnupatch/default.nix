{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "gnupatch-2.5.4";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/patch-2.5.4.tar.gz;
    md5 = "ee5ae84d115f051d87fcaaef3b4ae782";
  };
}
