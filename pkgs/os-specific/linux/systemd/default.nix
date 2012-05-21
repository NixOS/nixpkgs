{ stdenv, fetchurl, pkgconfig, intltool, gperf, libcap, udev, dbus, kmod
, xz, pam, acl, cryptsetup, libuuid, m4 }:

stdenv.mkDerivation rec {
  name = "systemd-44";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/systemd/${name}.tar.xz";
    sha256 = "0g138b5yvn419xqrakpk75q2sb4g7pj10br9b6zq4flb9d5sqnks";
  };

  buildInputs =
    [ pkgconfig intltool gperf libcap udev dbus kmod xz pam acl
      cryptsetup libuuid m4
    ];

  configureFlags =
    [ "--localstatedir=/var"
      "--with-distro=other"
      "--with-rootprefix=$(out)"
      "--with-rootprefix=$(out)"
      "--with-dbusinterfacedir=$(out)/share/dbus-1/interfaces"
      "--with-dbuspolicydir=$(out)/etc/dbus-1/system.d"
      "--with-dbussystemservicedir=$(out)/share/dbus-1/system-services"
      "--with-dbussessionservicedir=$(out)/share/dbus-1/services"
    ];

  installFlags = "localstatedir=$(TMPDIR)/var";

  enableParallelBuilding = true;
  
  meta = {
    homepage = http://www.freedesktop.org/wiki/Software/systemd;
    description = "A system and service manager for Linux";
  };
}
