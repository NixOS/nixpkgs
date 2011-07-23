{ stdenv, fetchurl, pkgconfig, sg3_utils, udev, glib, dbus, dbus_glib
, polkit, parted, lvm2, libatasmart, intltool, libuuid, mdadm
, libxslt, docbook_xsl, utillinux }:

stdenv.mkDerivation rec {
  name = "udisks-1.0.3";

  src = fetchurl {
    url = "http://hal.freedesktop.org/releases/${name}.tar.gz";
    sha256 = "0jwavs2ag0cv46517j17943s16a8fw2lqk4k3cljgivh5aswwnyr";
  };

  buildInputs =
    [ pkgconfig sg3_utils udev glib dbus dbus_glib polkit parted
      lvm2 libatasmart intltool libuuid libxslt docbook_xsl
    ];

  configureFlags = "--localstatedir=/var";

  preConfigure =
    ''
      # Ensure that udisks can find the necessary programs.
      substituteInPlace src/main.c --replace \
        "/sbin:/bin:/usr/sbin:/usr/bin" \
        "${utillinux}/bin:${mdadm}/sbin:/var/run/current-system/sw/bin:/var/run/current-system/sw/sbin"
    '';

  meta = {
    homepage = http://www.freedesktop.org/wiki/Software/udisks;
    description = "A daemon and command-line utility for querying and manipulating storage devices";
  };
}
