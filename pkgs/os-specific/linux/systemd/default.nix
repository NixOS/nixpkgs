{ stdenv, fetchurl, pkgconfig, intltool, gperf, libcap, dbus, kmod
, xz, pam, acl, cryptsetup, libuuid, m4, utillinux
, glib, kbd, libxslt, coreutils, libgcrypt, docbook_xsl
, kexectools, libmicrohttpd, bash, glibc, autoreconfHook
, python ? null, pythonSupport ? false
}:

assert stdenv.isLinux;

assert pythonSupport -> python != null;

stdenv.mkDerivation rec {
  version = "211";
  name = "systemd-${version}";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/systemd/${name}.tar.xz";
    sha256 = "0j36a4z6gqa0laxf3admd1w1mb8fdbnh3zvz1zgzl3hgdzzw2y7j";
  };

  patches = [ ./fix_console_in_containers.patch ]
    ++ stdenv.lib.optional stdenv.isArm ./libc-bug-accept4-arm.patch;

  buildInputs =
    [ pkgconfig intltool gperf libcap dbus.libs kmod xz pam acl
      /* cryptsetup */ libuuid m4 glib libxslt libgcrypt docbook_xsl
      libmicrohttpd autoreconfHook
    ] ++ stdenv.lib.optional pythonSupport python;

  propagatedBuildInputs = [ bash coreutils utillinux kbd glibc ];

  # Systemd attempts to use the gold linker instead of plain ld
  # This does not work with nix as gold is not properly patched to handle
  # all link time dependencies in the nix store
  # FIXME: When gold can be used with nix
  preAutoreconf = "sed -i 's/-Wl,-fuse-ld=gold//' configure.ac";

  configureFlags =
    [ "--localstatedir=/var"
      "--sysconfdir=$(out)/etc"
      "--with-rootprefix=$(out)"
      "--with-kbd-loadkeys=${kbd}/bin/loadkeys"
      "--with-kbd-setfont=${kbd}/bin/setfont"
      "--with-rootprefix=$(out)"
      "--with-sysvinit-path=$(out)/etc/init.d"
      "--with-dbusinterfacedir=$(out)/share/dbus-1/interfaces"
      "--with-dbuspolicydir=$(out)/etc/dbus-1/system.d"
      "--with-dbussystemservicedir=$(out)/share/dbus-1/system-services"
      "--with-dbussessionservicedir=$(out)/share/dbus-1/services"
      "--with-firmware-path=/root/test-firmware:/run/current-system/firmware"
      "--with-tty-gid=3" # tty in NixOS has gid 3
    ];

  preConfigure =
    ''
      # FIXME: patch this in systemd properly (and send upstream).
      for i in src/remount-fs/remount-fs.c src/core/mount.c src/core/swap.c src/fsck/fsck.c units/emergency.service.in units/systemd-readahead-drop.service units/rescue.service.m4.in src/journal/cat.c src/core/shutdown.c src/dbus1-generator/dbus1-generator.c src/hostname/org.freedesktop.hostname1.service src/kernel-install/* src/locale/*.service src/nspawn/nspawn.c; do
        test -e $i
        substituteInPlace $i \
          --replace /bin/bash ${bash}/bin/bash \
          --replace /bin/getent ${glibc}/bin/getent \
          --replace /bin/mount ${utillinux}/bin/mount \
          --replace /bin/umount ${utillinux}/bin/umount \
          --replace /sbin/swapon ${utillinux}/sbin/swapon \
          --replace /sbin/swapoff ${utillinux}/sbin/swapoff \
          --replace /sbin/fsck ${utillinux}/sbin/fsck \
          --replace /bin/echo ${coreutils}/bin/echo \
          --replace /bin/cat ${coreutils}/bin/cat \
          --replace /sbin/sulogin ${utillinux}/sbin/sulogin \
          --replace /sbin/kexec ${kexectools}/sbin/kexec \
          --replace /bin/false ${coreutils}/bin/false \
          --replace /bin/rm ${coreutils}/bin/rm
      done

      substituteInPlace src/journal/catalog.c \
        --replace /usr/lib/systemd/catalog/ $out/lib/systemd/catalog/
    '';

  PYTHON_BINARY = "${coreutils}/bin/env python"; # don't want a build time dependency on Python

  NIX_CFLAGS_COMPILE =
    [ # Can't say ${polkit}/bin/pkttyagent here because that would
      # lead to a cyclic dependency.
      "-UPOLKIT_AGENT_BINARY_PATH" "-DPOLKIT_AGENT_BINARY_PATH=\"/run/current-system/sw/bin/pkttyagent\""
      "-fno-stack-protector"

      # Work around our kernel headers being too old.  FIXME: remove
      # this after the next stdenv update.
      #"-DFS_NOCOW_FL=0x00800000"

      # Set the release_agent on /sys/fs/cgroup/systemd to the
      # currently running systemd (/run/current-system/systemd) so
      # that we don't use an obsolete/garbage-collected release agent.
      "-USYSTEMD_CGROUP_AGENT_PATH" "-DSYSTEMD_CGROUP_AGENT_PATH=\"/run/current-system/systemd/lib/systemd/systemd-cgroups-agent\""
    ];

  # Use /var/lib/udev rather than /etc/udev for the generated hardware
  # database.  Upstream doesn't want this (see commit
  # 1e1954f53386cb773e2a152748dd31c4d36aa2d8) because using /var is
  # forbidden in early boot, but in NixOS the initrd guarantees that
  # /var is mounted.
  makeFlags = "hwdb_bin=/var/lib/udev/hwdb.bin";

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

      # Fix reference to /bin/false in the D-Bus services.
      for i in $out/share/dbus-1/system-services/*.service; do
        substituteInPlace $i --replace /bin/false ${coreutils}/bin/false
      done

      rm -rf $out/etc/rpm
    ''; # */

  enableParallelBuilding = true;

  # The interface version prevents NixOS from switching to an
  # incompatible systemd at runtime.  (Switching across reboots is
  # fine, of course.)  It should be increased whenever systemd changes
  # in a backwards-incompatible way.  If the interface version of two
  # systemd builds is the same, then we can switch between them at
  # runtime; otherwise we can't and we need to reboot.
  passthru.interfaceVersion = 3;

  passthru.headers = stdenv.mkDerivation {
    name = "systemd-headers-${version}";
    inherit src;

    phases = [ "unpackPhase" "installPhase" ];

    # some are needed by dbus.libs, which is needed for systemd :-)
    installPhase = ''
      mkdir -p "$out/include/systemd"
      mv src/systemd/*.h "$out/include/systemd"
    '';
  };

  meta = with stdenv.lib; {
    homepage = "http://www.freedesktop.org/wiki/Software/systemd";
    description = "A system and service manager for Linux";
    platforms = platforms.linux;
    maintainers = with maintainers; [ eelco simons ];
  };
}
