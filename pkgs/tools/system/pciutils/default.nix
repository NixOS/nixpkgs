{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  name = "pciutils-3.1.7";
  
  src = fetchurl {
    url = "mirror://kernel/software/utils/pciutils/${name}.tar.bz2";
    sha256 = "0i7mqf1fkmdqsawdk2badv6k3xrkryq0i2xknclvy6kcjsv27znq";
  };
  
  buildInputs = [ zlib ];

  pciids = fetchurl {
    # Obtained from http://pciids.sourceforge.net/v2.2/pci.ids.bz2.
    url = http://nixos.org/tarballs/pci.ids.20100714.bz2;
    sha256 = "0vll4svr60l6217yna7bfhcjm3prxr2b62ynq4jaagdp1rilfbap";
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
