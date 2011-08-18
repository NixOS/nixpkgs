{ stdenv, fetchurl, pkgconfig, sg3_utils, udev, glib, dbus, dbus_glib
, polkit, parted, lvm2, libatasmart, intltool, libuuid, mdadm
, libxslt, docbook_xsl, utillinux, automake, autoconf }:

stdenv.mkDerivation rec {
  name = "udisks-1.0.3";

  src = fetchurl {
    url = "http://hal.freedesktop.org/releases/${name}.tar.gz";
    sha256 = "0jwavs2ag0cv46517j17943s16a8fw2lqk4k3cljgivh5aswwnyr";
  };

  # Move 80-udisks.rules manually to make the patch smaller
  prePatch = "mv -v data/80-udisks.rules{,.in}";

  # Not written a patch that can be accepted upstream yet
  postPatch = "sed -e 's@/sbin/mdadm@${mdadm}&@' -i data/80-udisks.rules.in";

  patches = [ ./purity.patch ];


  buildInputs =
    [ sg3_utils udev glib dbus dbus_glib polkit parted
      lvm2 libatasmart intltool libuuid libxslt docbook_xsl
    ];

  buildNativeInputs = [ automake autoconf pkgconfig ];

  configureFlags = "--localstatedir=/var";

  preConfigure =
    ''
      # Ensure that udisks can find the necessary programs.
      substituteInPlace src/main.c --replace \
        "/sbin:/bin:/usr/sbin:/usr/bin" \
        "${utillinux}/bin:${mdadm}/sbin:/var/run/current-system/sw/bin:/var/run/current-system/sw/sbin"

      automake
    '';

  meta = {
    homepage = http://www.freedesktop.org/wiki/Software/udisks;
    description = "A daemon and command-line utility for querying and manipulating storage devices";
    platforms = stdenv.lib.platforms.linux;
  };
}
