{stdenv, fetchurl, zlib}:

stdenv.mkDerivation {
  name = "pciutils-2.2.4";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://atrey.karlin.mff.cuni.cz/pub/linux/pci/pciutils-2.2.4.tar.gz;
    sha256 = "17vaa1rij0q2xj8z8b8c6qq7a4g65gj419dsz067zlf6i3v0gz32";
  };
  buildInputs = [zlib];

  pciids = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/pci.ids.20070226.bz2;
    sha256 = "1wrpq4dxm03v5jvvdlvwl8nrkj3hspgifkw5czmd647lzikp13qc";
  };
}
