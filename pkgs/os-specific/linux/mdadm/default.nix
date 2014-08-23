{ stdenv, fetchurl, groff }:

stdenv.mkDerivation rec {
  name = "mdadm-3.3";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/raid/mdadm/${name}.tar.bz2";
    sha256 = "0igdqflihiq1dp5qlypzw0xfl44f4n3bckl7r2x2wfgkplcfa1ww";
  };

  nativeBuildInputs = [ groff ];

  preConfigure = "sed -e 's@/lib/udev@\${out}/lib/udev@' -e 's@ -Werror @ @' -i Makefile";

  # Force mdadm to use /var/run/mdadm.map for its map file (or
  # /dev/.mdadm/map as a fallback).
  preBuild =
    ''
      makeFlagsArray=(INSTALL=install BINDIR=$out/sbin MANDIR=$out/share/man RUN_DIR=/dev/.mdadm)
      if [[ -n "$crossConfig" ]]; then
        makeFlagsArray+=(CROSS_COMPILE=$crossConfig-)
      fi
    '';

  meta = {
    description = "Programs for managing RAID arrays under Linux";
    homepage = http://neil.brown.name/blog/mdadm;
  };
}
