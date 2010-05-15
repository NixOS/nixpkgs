{stdenv, fetchurl, groff}:

stdenv.mkDerivation rec {
  name = "mdadm-3.1.2";
  src = fetchurl {
    url = "mirror://kernel/linux/utils/raid/mdadm/${name}.tar.bz2";
    sha256 = "0s2d2a01j8cizxqvbgd0sn5bpa1j46q8976078b3jq1q7i1ir0zz";
  };

  buildNativeInputs = [groff];

  patchPhase = "sed -e 's@/lib/udev@\${out}/lib/udev@' -i Makefile";

  preBuild =
    ''
      makeFlagsArray=(INSTALL=install BINDIR=$out/sbin MANDIR=$out/share/man)
      if [[ -n "$crossConfig" ]]; then
        makeFlagsArray+=(CROSS_COMPILE=$crossConfig-)
      fi
    '';

  meta = {
    description = "Programs for managing RAID arrays under Linux";
  };
}
