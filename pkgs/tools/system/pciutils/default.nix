{stdenv, fetchurl, zlib}:

stdenv.mkDerivation {
  name = "pciutils-3.0.0";
  
  builder = ./builder.sh;
  
  src = fetchurl {
    url = mirror://kernel/software/utils/pciutils/pciutils-3.0.0.tar.bz2;
    sha256 = "1q9j7w95ysy6c02j7p3z58y23n5v2cdjwy6hz8s9xzvnlr0ynpnh";
  };
  
  buildInputs = [zlib];

  pciids = fetchurl {
    url = http://nixos.org/tarballs/pci.ids.20080830.bz2;
    sha256 = "0nfjj9lsifmm6js9w0isrscirr1a7dj9ynppbc0g5i19rzrmwafy";
  };

  # Override broken auto-detect logic.
  makeFlags = "ZLIB=yes DNS=yes";

  installTargets = "install install-lib";

  meta = {
    homepage = http://mj.ucw.cz/pciutils.shtml;
    description = "A collection of programs for inspecting and manipulating configuration of PCI devices";
  };
}
