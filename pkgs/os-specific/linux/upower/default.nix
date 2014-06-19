{ stdenv, fetchurl, fetchpatch, pkgconfig, glib, dbus, dbus_glib, dbus_tools, polkit
, intltool, libxslt, docbook_xsl, udev, libusb1, pmutils
, useSystemd ? true, systemd, gobjectIntrospection
}:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "upower-0.9.23";

  src = fetchurl {
    url = "http://upower.freedesktop.org/releases/${name}.tar.xz";
    sha256 = "06wqhab2mn0j4biiwh7mn4kxbxnfnzjkxvhpgvnlpaz9m2q54cj3";
  };

  patches = [
    (fetchpatch rec {
      url = "http://anonscm.debian.org/gitweb/?p=pkg-utopia/upower.git;"
        + "a=blob_plain;f=debian/patches/${name};hb=b424b2763fbbba95df8c6ab3feeb57d072a9ddf7";
      sha256 = "0iq991abrn745icyz6x0wyixrjli01vbmbd9lnwwgyil58h3z8sp";
      name = "no_deprecation_define.patch";
    })
    (fetchpatch {
      url = "http://cgit.freedesktop.org/upower/patch/?id=22da1a0bc5943b683189418d8b0f766e91b2bdbe";
      sha256 = "0yfgg6pw4bwskannvdwjxr75lgdrjpxhsskwlzm0frp8v5jy4k4z";
      name = "clamp-battery-percentages.patch";
    })
  ];

  buildInputs =
    [ dbus_glib polkit intltool libxslt docbook_xsl udev libusb1 gobjectIntrospection ]
    ++ stdenv.lib.optional useSystemd systemd;

  nativeBuildInputs = [ pkgconfig ];

  preConfigure =
    ''
      substituteInPlace src/linux/up-backend.c \
        --replace /usr/bin/pm- ${pmutils}/bin/pm- \
        --replace /usr/sbin/pm- ${pmutils}/sbin/pm-
      substituteInPlace src/notify-upower.sh \
        --replace /usr/bin/dbus-send ${dbus_tools}/bin/dbus-send
    '';

  configureFlags =
    [ "--with-backend=linux" "--localstatedir=/var"
      "--enable-deprecated" # needed for Xfce (Nov 2013)
    ]
    ++ stdenv.lib.optional useSystemd
    [ "--enable-systemd"
      "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
      "--with-systemdutildir=$(out)/lib/systemd/system-sleep"
      "--with-udevrulesdir=$(out)/lib/udev/rules.d"
    ];

  NIX_CFLAGS_LINK = "-lgcc_s";

  installFlags = "historydir=$(TMPDIR)/foo";

  meta = {
    homepage = http://upower.freedesktop.org/;
    description = "A D-Bus service for power management";
    platforms = stdenv.lib.platforms.linux;
  };
}
