{ stdenv, fetchurl, pkgconfig, sg3_utils, udev, glib, dbus, dbus_glib
, polkit, parted, lvm2, libatasmart, intltool, libuuid, mdadm
, libxslt, docbook_xsl, utillinux }:

stdenv.mkDerivation rec {
  name = "udisks-1.0.4";

  src = fetchurl {
    url = "http://hal.freedesktop.org/releases/${name}.tar.gz";
    sha256 = "1xgqifddwaavmjc8c30i0mdffyirsld7c6qhfyjw7f9khwv8jjw5";
  };

  patches = [ ./purity.patch ];

  postPatch =
    ''
      sed -e 's,/sbin/mdadm,${mdadm}&,g' -e "s,@slashlibdir@,$out/lib,g" -i data/80-udisks.rules

      substituteInPlace src/main.c --replace \
        "/sbin:/bin:/usr/sbin:/usr/bin" \
        "${utillinux}/bin:${mdadm}/sbin:/var/run/current-system/sw/bin:/var/run/current-system/sw/sbin"
    '';

  buildInputs =
    [ sg3_utils udev glib dbus dbus_glib polkit parted
      lvm2 libatasmart intltool libuuid libxslt docbook_xsl
    ];

  nativeBuildInputs = [ pkgconfig ];

  configureFlags = "--localstatedir=/var --enable-lvm2";

  preConfigure =
    ''
      # Ensure that udisks can find the necessary programs.
    '';

  meta = {
    homepage = http://www.freedesktop.org/wiki/Software/udisks;
    description = "A daemon and command-line utility for querying and manipulating storage devices";
    platforms = stdenv.lib.platforms.linux;
  };
}
