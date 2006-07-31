{stdenv, fetchurl, gettext}:

stdenv.mkDerivation {
  name = "e2fsprogs-1.36";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/e2fsprogs-1.36.tar.gz;
    md5 = "1804ee96b76e5e7113fe3cecd6fe582b";
  };
  buildInputs = [gettext];
}
