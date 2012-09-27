{ stdenv, fetchurl, pkgconfig, intltool, gperf, libcap, dbus, kmod
, xz, pam, acl, cryptsetup, libuuid, m4, utillinux, usbutils, pciutils
, glib, kbd, libxslt
}:

assert stdenv.gcc.libc or null != null;

stdenv.mkDerivation rec {
  name = "systemd-192";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/systemd/${name}.tar.xz";
    sha256 = "03y3y1w3x7bx67jvdxryhns3h1g6nrllln46gqipp35n99alki2m";
  };

  patches = [ ./reexec.patch ];

  buildInputs =
    [ pkgconfig intltool gperf libcap dbus kmod xz pam acl
      /* cryptsetup */ libuuid m4 usbutils pciutils glib libxslt
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
      "--with-firmware-path=/root/test-firmware:/var/run/current-system/firmware"
      "--with-pci-ids-path=${pciutils}/share/pci.ids"
      "--with-tty-gid=3" # tty in NixOS has gid 3
    ];

  preConfigure =
    ''
      # FIXME: patch this in systemd properly (and send upstream).
      for i in src/remount-fs/remount-fs.c src/core/mount.c src/core/swap.c src/fsck/fsck.c; do
        test -e $i
        substituteInPlace $i \
          --replace /bin/mount ${utillinux}/bin/mount \
          --replace /bin/umount ${utillinux}/bin/umount \
          --replace /sbin/swapon ${utillinux}/sbin/swapon \
          --replace /sbin/swapoff ${utillinux}/sbin/swapoff \
          --replace /sbin/fsck ${utillinux}/sbin/fsck
      done
    '';

  NIX_CFLAGS_COMPILE =
    [ "-DKBD_LOADKEYS=\"${kbd}/bin/loadkeys\""
      "-DKBD_SETFONT=\"${kbd}/bin/setfont\""
      # Can't say ${polkit}/bin/pkttyagent here because that would
      # lead to a cyclic dependency.
      "-DPOLKIT_AGENT_BINARY_PATH=\"/run/current-system/sw/bin/pkttyagent\""
      "-fno-stack-protector"
    ];

  makeFlags = "CPPFLAGS=-I${stdenv.gcc.libc}/include";

  installFlags = "localstatedir=$(TMPDIR)/var sysconfdir=$(out)/etc";

  # Get rid of configuration-specific data.
  postInstall =
    ''
      mkdir -p $out/example/systemd
      mv $out/lib/{modules-load.d,binfmt.d,sysctl.d,tmpfiles.d} $out/example
      mv $out/lib/systemd/{system,user} $out/example/systemd

      # Install SysV compatibility commands.
      mkdir -p $out/sbin
      ln -s $out/lib/systemd/systemd $out/sbin/telinit
      for i in init halt poweroff runlevel reboot shutdown; do
        ln -s $out/bin/systemctl $out/sbin/$i
      done
    '';

  enableParallelBuilding = true;

  # The interface version prevents NixOS from switching to an
  # incompatible systemd at runtime.  (Switching across reboots is
  # fine, of course.)  It should be increased whenever systemd changes
  # in a backwards-incompatible way.  If the interface version of two
  # systemd builds is the same, then we can switch between them at
  # runtime; otherwise we can't and we need to reboot.
  passthru.interfaceVersion = 2;

  meta = {
    homepage = http://www.freedesktop.org/wiki/Software/systemd;
    description = "A system and service manager for Linux";
    platforms = stdenv.lib.platforms.linux;
  };
}
