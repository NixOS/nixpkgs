{stdenv, fetchurl, zlib}:

stdenv.mkDerivation {
  name = "pciutils-2.2.8";
  builder = ./builder.sh;
  src = fetchurl {
    url = mirror://kernel/software/utils/pciutils/pciutils-2.2.8.tar.bz2;
    sha256 = "0hgri2ancnjl56ld2flb9w606dyvr5gly8gsz3bzl71r8s464qsq";
  };
  buildInputs = [zlib];

  pciids = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/pci.ids.20080118.bz2;
    sha256 = "0dl6psdac62llbklxn4dvkzbw1j1sdadw9i4l36vpd6mvqa7lz0a";
  };
}
