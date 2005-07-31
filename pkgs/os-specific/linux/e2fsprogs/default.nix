{stdenv, fetchurl, gettext}:

stdenv.mkDerivation {
  name = "e2fsprogs-1.36";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/e2fsprogs-1.36.tar.gz;
    md5 = "1804ee96b76e5e7113fe3cecd6fe582b";
  };
  configureFlags = "--enable-dynamic-e2fsck --enable-elf-shlibs";
  buildInputs = [gettext];
}
