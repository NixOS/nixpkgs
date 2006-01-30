{stdenv, fetchurl, gettext}:

stdenv.mkDerivation {
  name = "e2fsprogs-1.38";
  builder = ./builder.sh;
  src = fetchurl {
    #url = http://nix.cs.uu.nl/dist/tarballs/e2fsprogs-1.36.tar.gz;
    url = http://nix.cs.uu.nl/dist/tarballs/e2fsprogs-1.38.tar.gz;
    md5 = "d774d4412bfb80d12cf3a4fdfd59de5a";
  };
  configureFlags = "--enable-dynamic-e2fsck --enable-elf-shlibs";
  buildInputs = [gettext];
}


