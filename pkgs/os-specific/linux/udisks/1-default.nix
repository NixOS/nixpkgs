{ stdenv, fetchurl, pkgconfig, sg3_utils, udev, glib, dbus, dbus_glib
, polkit, parted, lvm2, libatasmart, intltool, libuuid, mdadm
, libxslt, docbook_xsl, utillinux }:

stdenv.mkDerivation rec {
  name = "udisks-1.0.5";

  src = fetchurl {
    url = "http://hal.freedesktop.org/releases/${name}.tar.gz";
    sha256 = "0wbg3jrv8limdgvcygf4dqin3y6d30y9pcmmk711vq571vmq5v7j";
  };

  patches = [ ./purity.patch ./no-pci-db.patch ];

  postPatch =
    ''
      sed -e 's,/sbin/mdadm,${mdadm}&,g' -e "s,@slashlibdir@,$out/lib,g" -i data/80-udisks.rules

      substituteInPlace src/main.c --replace \
        "/sbin:/bin:/usr/sbin:/usr/bin" \
        "${utillinux}/bin:${mdadm}/sbin:/var/run/current-system/sw/bin:/var/run/current-system/sw/sbin"

      # For some reason @libexec@ is set to 'lib/' when building.
      # Passing --libexecdir in configureFlags didn't help.
      substituteInPlace data/systemd/udisks.service.in \
        --replace "@libexecdir@" "$out/libexec"
    '';

  buildInputs =
    [ sg3_utils udev glib dbus dbus_glib polkit parted
      lvm2 libatasmart intltool libuuid libxslt docbook_xsl
    ];

  nativeBuildInputs = [ pkgconfig ];

  configureFlags = [
    "--localstatedir=/var"
    "--enable-lvm2"
    "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
  ];

  meta = {
    homepage = http://www.freedesktop.org/wiki/Software/udisks;
    description = "A daemon and command-line utility for querying and manipulating storage devices";
    platforms = stdenv.lib.platforms.linux;
  };
}
