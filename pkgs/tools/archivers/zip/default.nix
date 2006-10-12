{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "zip-2.32";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/zip232.tar.gz;
    md5 = "8a4da4460386e324debe97f3b7fe4d96";
  };
}
