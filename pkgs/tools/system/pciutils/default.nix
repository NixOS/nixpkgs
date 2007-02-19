{stdenv, fetchurl, zlib}:

stdenv.mkDerivation {
  name = "pciutils-2.2.4";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://atrey.karlin.mff.cuni.cz/pub/linux/pci/pciutils-2.2.4.tar.gz;
    sha256 = "17vaa1rij0q2xj8z8b8c6qq7a4g65gj419dsz067zlf6i3v0gz32";
  };
  buildInputs = [zlib];
}
