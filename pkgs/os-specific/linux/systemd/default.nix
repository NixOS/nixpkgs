{ stdenv, fetchurl, pkgconfig, intltool, gperf, libcap, udev, dbus, kmod
, xz, pam, acl, cryptsetup, libuuid, m4, utillinux }:

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
      "--sysconfdir=/etc"
      "--with-distro=other"
      "--with-rootprefix=$(out)"
      "--with-rootprefix=$(out)"
      "--with-dbusinterfacedir=$(out)/share/dbus-1/interfaces"
      "--with-dbuspolicydir=$(out)/etc/dbus-1/system.d"
      "--with-dbussystemservicedir=$(out)/share/dbus-1/system-services"
      "--with-dbussessionservicedir=$(out)/share/dbus-1/services"
    ];

  preConfigure =
    ''
      for i in units/remount-rootfs.service src/remount-api-vfs.c src/mount.c; do
        substituteInPlace $i \
          --replace /bin/mount ${utillinux}/bin/mount \
          --replace /bin/umount ${utillinux}/bin/umount
      done
    '';

  installFlags = "localstatedir=$(TMPDIR)/var sysconfdir=$(out)/etc";

  # Get rid of configuration-specific data.
  postInstall =
    ''
      mkdir -p $out/example/systemd
      mv $out/lib/{modules-load.d,binfmt.d,sysctl.d,tmpfiles.d} $out/example
      mv $out/lib/systemd/{system,user} $out/example/systemd
    '';

  enableParallelBuilding = true;
  
  meta = {
    homepage = http://www.freedesktop.org/wiki/Software/systemd;
    description = "A system and service manager for Linux";
  };
}
