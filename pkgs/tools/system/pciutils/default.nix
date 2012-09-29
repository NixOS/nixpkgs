{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  name = "pciutils-3.1.10";

  src = fetchurl {
    url = "mirror://kernel/software/utils/pciutils/${name}.tar.bz2";
    sha256 = "0xdahcxd00c921wnxi0f0w3lzjqdfphwa5vglfcpf0lv3l2w40pl";
  };

  buildInputs = [ zlib ];

  pciids = fetchurl {
    # Obtained from http://pciids.sourceforge.net/v2.2/pci.ids.bz2.
    url = http://nixos.org/tarballs/pci.ids.20120929.bz2;
    sha256 = "1q3i479ay88wam1zz1vbgkbqb2axg8av9qjxaigrqbnw2pv0srmb";
  };

  # Override broken auto-detect logic.
  # Note: we can't compress pci.ids (ZLIB=yes) because udev requires
  # an uncompressed pci.ids.
  makeFlags = "ZLIB=no DNS=yes SHARED=yes PREFIX=\${out}";

  preBuild = ''
    bunzip2 < $pciids > pci.ids
  '';

  installTargets = "install install-lib";

  # Get rid of update-pciids as it won't work.
  postInstall = "rm $out/sbin/update-pciids $out/man/man8/update-pciids.8";

  meta = {
    homepage = http://mj.ucw.cz/pciutils.shtml;
    description = "A collection of programs for inspecting and manipulating configuration of PCI devices";
  };
}
