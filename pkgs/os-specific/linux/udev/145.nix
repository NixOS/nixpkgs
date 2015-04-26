{ stdenv, fetchurl, gperf, pkgconfig, glib, acl, libusb, usbutils, pciutils }:

assert stdenv ? glibc;

stdenv.mkDerivation rec {
  name = "udev-145";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/kernel/hotplug/${name}.tar.bz2";
    sha256 = "1zmibp6n7d582fqx8vmg9vb2a1435hghfpz36056bc25ccwf7yiv";
  };

  buildInputs = [gperf pkgconfig glib acl libusb usbutils];

  configureFlags = "--with-pci-ids-path=${pciutils}/share/pci.ids";

  preConfigure =
    ''
      substituteInPlace extras/keymap/Makefile.in \
        --replace /usr/include ${stdenv.glibc.dev}/include
    '';

  postInstall =
    ''
      # Install some rules that really should be installed by default.
      for i in 40-alsa.rules 40-infiniband.rules 40-isdn.rules 40-pilot-links.rules 64-device-mapper.rules 64-md-raid.rules; do
        cp rules/packages/$i $out/libexec/rules.d/
      done

      # The path to rule_generator.functions in write_cd_rules and
      # write_net_rules is broken.  Also, don't store the mutable
      # persistant rules in /etc/udev/rules.d but in
      # /var/lib/udev/rules.d.
      for i in $out/libexec/write_cd_rules $out/libexec/write_net_rules; do
        substituteInPlace $i \
          --replace /lib/udev $out/libexec \
          --replace /etc/udev/rules.d /var/lib/udev/rules.d
      done

      # Don't set PATH to /bin:/sbin; won't work in NixOS.
      substituteInPlace $out/libexec/rule_generator.functions \
        --replace 'PATH=' '#PATH='

      # Don't hardcore the FIRMWARE_DIRS variable; obtain it from the
      # environment of the caller.
      sed '3,4d' -i $out/libexec/firmware.sh
    '';

  meta = {
    homepage = http://www.kernel.org/pub/linux/utils/kernel/hotplug/udev.html;
    description = "Udev manages the /dev filesystem";
  };
}
