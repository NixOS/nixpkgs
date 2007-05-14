{stdenv, fetchurl, zlib}:

stdenv.mkDerivation {
  name = "pciutils-2.2.5";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.kernel.org/pub/software/utils/pciutils/pciutils-2.2.5.tar.bz2;
    sha256 = "1zlamdax1i8cf3kvzg7dh7nshvvzlhvkwlxdmym0hbnmbf0p100p";
  };
  buildInputs = [zlib];

  pciids = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/pci.ids.20070226.bz2;
    sha256 = "1wrpq4dxm03v5jvvdlvwl8nrkj3hspgifkw5czmd647lzikp13qc";
  };
}
