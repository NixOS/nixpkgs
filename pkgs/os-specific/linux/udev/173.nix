{ stdenv, fetchurl, gperf, pkgconfig, glib, acl
, libusb, usbutils, pciutils }:

assert stdenv ? glibc;

stdenv.mkDerivation rec {
  name = "udev-173";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/kernel/hotplug/${name}.tar.bz2";
    sha256 = "1bxadi4bi11v8ipzj22wknv8hsb0wgdb99bx3w9w33rgl4aq78bh";
  };

  buildInputs = [ gperf pkgconfig glib acl libusb usbutils ];

  configureFlags =
    ''
      --with-pci-ids-path=${pciutils}/share/pci.ids
      --enable-udev_acl --enable-edd
      --disable-introspection --libexecdir=$(out)/lib/udev
      --with-firmware-path=/root/test-firmware:/var/run/current-system/firmware
    '';

  # Workaround for the Linux kernel headers being too old.
  NIX_CFLAGS_COMPILE = "-DBTN_TRIGGER_HAPPY=0x2c0";

  postInstall =
    ''
      # The path to rule_generator.functions in write_cd_rules and
      # write_net_rules is broken.  Also, don't store the mutable
      # persistant rules in /etc/udev/rules.d but in
      # /var/lib/udev/rules.d.
      for i in $out/lib/udev/write_cd_rules $out/lib/udev/write_net_rules; do
        substituteInPlace $i \
          --replace /lib/udev $out/lib/udev \
          --replace /etc/udev/rules.d /var/lib/udev/rules.d
      done

      # Don't set PATH to /bin:/sbin; won't work in NixOS.
      sed -e '/PATH=/d' -i $out/lib/udev/rule_generator.functions

      ln -sv $out/lib/ConsoleKit $out/etc/ConsoleKit

      rm -frv $out/share/gtk-doc
    '';

  patches = [ ./custom-rules.patch ] ++
    [(fetchurl {
      url = https://bugs.archlinux.org/task/25356?getfile=7281;
      sha256 = "01xib1pfdbwacgx8dqxgrf67a0mwkpm4kxy9f9v3df93v0m4pmbm";
    })] ++
    stdenv.lib.optional (stdenv.system == "armv5tel-linux") ./pre-accept4-kernel.patch;

  meta = {
    homepage = http://www.kernel.org/pub/linux/utils/kernel/hotplug/udev.html;
    description = "Udev manages the /dev filesystem";
  };
}
