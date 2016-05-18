{ stdenv, fetchurl, pkgconfig
, pciutils, utillinux, kmod, usbutils, gperf
}:

assert stdenv ? glibc;

stdenv.mkDerivation rec {
  name = "udev-182";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/kernel/hotplug/${name}.tar.bz2";
    sha256 = "143qvm0kij26j2l5icnch4x38fajys6li7j0c5mpwi6kqmc8hqx0";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ utillinux kmod usbutils #glib gobjectIntrospection
                  gperf
                ];

  configureFlags = [ "--with-pci-ids-path=${pciutils}/share/pci.ids"
                     "--disable-gudev"
                     "--disable-introspection"
                   ];

  postPatch = ''
    sed -i 's:input.h:input-event-codes.h:' Makefile.in
    sed -i '20a#include <stdint.h>' src/mtd_probe/mtd_probe.h
  '';

  NIX_LDFLAGS = [ "-lrt" ];

  meta = with stdenv.lib; {
    homepage = http://www.kernel.org/pub/linux/utils/kernel/hotplug/udev.html;
    description = "Udev manages the /dev filesystem";
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
