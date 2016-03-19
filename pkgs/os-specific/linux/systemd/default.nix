{ stdenv, fetchFromGitHub, pkgconfig, intltool, gperf, libcap, dbus, kmod
, xz, pam, acl, cryptsetup, libuuid, m4, utillinuxMinimal
, glib, kbd, libxslt, coreutils, libgcrypt, libgpgerror, libapparmor, audit, lz4
, kexectools, libmicrohttpd, linuxHeaders, libseccomp
, autoreconfHook, gettext, docbook_xsl, docbook_xml_dtd_42, docbook_xml_dtd_45
, enableKDbus ? false
}:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  version = "229";
  name = "systemd-${version}";

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "systemd";
    rev = "4936f6e6c05162516a685ebd227b55816cf2b670";
    sha256 = "1q0pyrljmq73qcan9rfqsiw66l1g159m5in5qgb8zwlwhl928670";
  };

  outputs = [ "out" "man" "doc" ];

  buildInputs =
    [ linuxHeaders pkgconfig intltool gperf libcap kmod xz pam acl
      cryptsetup libuuid m4 glib libxslt libgcrypt libgpgerror
      libmicrohttpd kexectools libseccomp audit lz4 libapparmor
      /* FIXME: we may be able to prevent the following dependencies
         by generating an autoconf'd tarball, but that's probably not
         worth it. */
      autoreconfHook gettext docbook_xsl docbook_xml_dtd_42 docbook_xml_dtd_45
    ];

  configureFlags =
    [ "--localstatedir=/var"
      "--sysconfdir=/etc"
      "--with-rootprefix=$(out)"
      "--with-kbd-loadkeys=${kbd}/bin/loadkeys"
      "--with-kbd-setfont=${kbd}/bin/setfont"
      "--with-rootprefix=$(out)"
      "--with-dbuspolicydir=$(out)/etc/dbus-1/system.d"
      "--with-dbussystemservicedir=$(out)/share/dbus-1/system-services"
      "--with-dbussessionservicedir=$(out)/share/dbus-1/services"
      "--with-tty-gid=3" # tty in NixOS has gid 3
      "--enable-compat-libs" # get rid of this eventually
      "--disable-tests"

      "--enable-lz4"
      "--enable-hostnamed"
      "--enable-networkd"
      "--disable-sysusers"
      "--enable-timedated"
      "--enable-timesyncd"
      "--disable-firstboot"
      "--enable-localed"
      "--enable-resolved"
      "--disable-split-usr"
      "--disable-libcurl"
      "--disable-libidn"
      "--disable-quotacheck"
      "--disable-ldconfig"
      "--disable-smack"

      "--with-sysvinit-path="
      "--with-sysvrcnd-path="
      "--with-rc-local-script-path-stop=/etc/halt.local"
    ] ++ (if enableKDbus then [ "--enable-kdbus" ] else [ "--disable-kdbus" ]);

  preConfigure =
    ''
      ./autogen.sh

      # FIXME: patch this in systemd properly (and send upstream).
      for i in src/remount-fs/remount-fs.c src/core/mount.c src/core/swap.c src/fsck/fsck.c units/emergency.service.in units/rescue.service.in src/journal/cat.c src/core/shutdown.c src/nspawn/nspawn.c src/shared/generator.c; do
        test -e $i
        substituteInPlace $i \
          --replace /usr/bin/getent ${stdenv.glibc}/bin/getent \
          --replace /bin/mount ${utillinuxMinimal}/bin/mount \
          --replace /bin/umount ${utillinuxMinimal}/bin/umount \
          --replace /sbin/swapon ${utillinuxMinimal}/sbin/swapon \
          --replace /sbin/swapoff ${utillinuxMinimal}/sbin/swapoff \
          --replace /bin/echo ${coreutils}/bin/echo \
          --replace /bin/cat ${coreutils}/bin/cat \
          --replace /sbin/sulogin ${utillinuxMinimal}/sbin/sulogin \
          --replace /usr/lib/systemd/systemd-fsck $out/lib/systemd/systemd-fsck
      done

      substituteInPlace src/journal/catalog.c \
        --replace /usr/lib/systemd/catalog/ $out/lib/systemd/catalog/

      configureFlagsArray+=("--with-ntp-servers=0.nixos.pool.ntp.org 1.nixos.pool.ntp.org 2.nixos.pool.ntp.org 3.nixos.pool.ntp.org")
    '';

  PYTHON_BINARY = "${coreutils}/bin/env python"; # don't want a build time dependency on Python

  NIX_CFLAGS_COMPILE =
    [ # Can't say ${polkit}/bin/pkttyagent here because that would
      # lead to a cyclic dependency.
      "-UPOLKIT_AGENT_BINARY_PATH" "-DPOLKIT_AGENT_BINARY_PATH=\"/run/current-system/sw/bin/pkttyagent\""
      "-fno-stack-protector"

      # Set the release_agent on /sys/fs/cgroup/systemd to the
      # currently running systemd (/run/current-system/systemd) so
      # that we don't use an obsolete/garbage-collected release agent.
      "-USYSTEMD_CGROUP_AGENT_PATH" "-DSYSTEMD_CGROUP_AGENT_PATH=\"/run/current-system/systemd/lib/systemd/systemd-cgroups-agent\""

      "-USYSTEMD_BINARY_PATH" "-DSYSTEMD_BINARY_PATH=\"/run/current-system/systemd/lib/systemd/systemd\""
    ];

  installFlags =
    [ "localstatedir=$(TMPDIR)/var"
      "sysconfdir=$(out)/etc"
      "sysvinitdir=$(TMPDIR)/etc/init.d"
      "pamconfdir=$(out)/etc/pam.d"
    ];

  postInstall =
    ''
      # sysinit.target: Don't depend on
      # systemd-tmpfiles-setup.service. This interferes with NixOps's
      # send-keys feature (since sshd.service depends indirectly on
      # sysinit.target).
      mv $out/lib/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup-dev.service $out/lib/systemd/system/multi-user.target.wants/

      mkdir -p $out/example/systemd
      mv $out/lib/{modules-load.d,binfmt.d,sysctl.d,tmpfiles.d} $out/example
      mv $out/lib/systemd/{system,user} $out/example/systemd

      rm -rf $out/etc/systemd/system

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

      rm $out/lib/*.la

      # "kernel-install" shouldn't be used on NixOS.
      find $out -name "*kernel-install*" -exec rm {} \;
    ''; # */

  enableParallelBuilding = true;

  # The interface version prevents NixOS from switching to an
  # incompatible systemd at runtime.  (Switching across reboots is
  # fine, of course.)  It should be increased whenever systemd changes
  # in a backwards-incompatible way.  If the interface version of two
  # systemd builds is the same, then we can switch between them at
  # runtime; otherwise we can't and we need to reboot.
  passthru.interfaceVersion = 2;

  meta = {
    homepage = "http://www.freedesktop.org/wiki/Software/systemd";
    description = "A system and service manager for Linux";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco stdenv.lib.maintainers.simons ];
  };
}
