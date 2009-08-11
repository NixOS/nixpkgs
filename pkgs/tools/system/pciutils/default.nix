{stdenv, fetchurl, zlib}:

stdenv.mkDerivation {
  name = "pciutils-3.1.2";
  
  src = fetchurl {
    url = mirror://kernel/software/utils/pciutils/pciutils-3.1.2.tar.bz2;
    sha256 = "15wksvqcgdj0hvsp5irc1igiqid69rrzpc33qj9nlyssvyw40vpn";
  };
  
  buildInputs = [zlib];

  pciids = fetchurl {
    # Obtained from http://pciids.sourceforge.net/v2.2/pci.ids.bz2.
    url = http://nixos.org/tarballs/pci.ids.20090727.bz2;
    sha256 = "0q7fs5ww92a6v5dc514ff4vy7v9hzpdqbd1agbafc2wk2zgi10mk";
  };

  # Override broken auto-detect logic.
  # Note: we can't compress pci.ids (ZLIB=yes) because udev requires
  # an uncompressed pci.ids.
  makeFlags = "ZLIB=no DNS=yes SHARED=yes PREFIX=\${out}";

  preBuild = ''
    bunzip2 < $pciids > pci.ids
  '';

  installTargets = "install install-lib";

  meta = {
    homepage = http://mj.ucw.cz/pciutils.shtml;
    description = "A collection of programs for inspecting and manipulating configuration of PCI devices";
  };
}
