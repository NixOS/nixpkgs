{ stdenv, fetchurl, pkgconfig, zlib, kmod, which }:

let
  pciids = fetchurl {
    # Obtained from http://pciids.sourceforge.net/v2.2/pci.ids.bz2.
    url = http://tarballs.nixos.org/pci.ids.20120929.bz2;
    sha256 = "1q3i479ay88wam1zz1vbgkbqb2axg8av9qjxaigrqbnw2pv0srmb";
  };
in
stdenv.mkDerivation rec {
  name = "pciutils-3.2.0";

  src = fetchurl {
    url = "mirror://kernel/software/utils/pciutils/${name}.tar.bz2";
    sha256 = "0d9as9jzjjg5c1nwf58z1y1i7rf9fqxmww1civckhcvcn0xr85mq";
  };

  buildInputs = [ pkgconfig zlib kmod which ];

  # currently up-to-date
  #preBuild = "bunzip2 < ${pciids} > pci.ids";

  makeFlags = "SHARED=yes PREFIX=\${out}";

  installTargets = "install install-lib";

  # Get rid of update-pciids as it won't work.
  postInstall = "rm $out/sbin/update-pciids $out/man/man8/update-pciids.8";

  meta = {
    homepage = http://mj.ucw.cz/pciutils.shtml;
    description = "A collection of programs for inspecting and manipulating configuration of PCI devices";
  };
}
