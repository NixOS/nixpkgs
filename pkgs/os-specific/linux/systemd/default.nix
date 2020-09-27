{ stdenv, lib, fetchFromGitHub, pkgconfig, intltool, gperf, libcap
, curl, kmod, gnupg, gnutar, xz, pam, acl, libuuid, m4, e2fsprogs, utillinux, libffi
, glib, kbd, libxslt, coreutils, libgcrypt, libgpgerror, libidn2, libapparmor
, audit, lz4, bzip2, libmicrohttpd, pcre2
, linuxHeaders ? stdenv.cc.libc.linuxHeaders
, iptables, gnu-efi, bashInteractive
, gettext, docbook_xsl, docbook_xml_dtd_42, docbook_xml_dtd_45
, ninja, meson, python3Packages, glibcLocales
, patchelf
, substituteAll
, getent
, cryptsetup, lvm2
, buildPackages
, perl
, withSelinux ? false, libselinux
, withLibseccomp ? lib.any (lib.meta.platformMatch stdenv.hostPlatform) libseccomp.meta.platforms, libseccomp
, withKexectools ? lib.any (lib.meta.platformMatch stdenv.hostPlatform) kexectools.meta.platforms, kexectools
}:

let
  version = "246.6";
in stdenv.mkDerivation {
  inherit version;
  pname = "systemd";

  # We use systemd/systemd-stable for src, and ship NixOS-specific patches inside nixpkgs directly
  # This has proven to be less error-prone than the previous systemd fork.
  src = fetchFromGitHub {
    owner = "systemd";
    repo = "systemd-stable";
    rev = "v${version}";
    sha256 = "1yhj2jlighqqpw1xk9q52f3pncjn47ipi224k35d6syb94q2b988";
  };

  # If these need to be regenerated, `git am path/to/00*.patch` them into a
  # systemd worktree, rebase to the more recent systemd version, and export the
  # patches again via `git format-patch v${version}`.
  patches = [
    ./0001-Start-device-units-for-uninitialised-encrypted-devic.patch
    ./0002-Don-t-try-to-unmount-nix-or-nix-store.patch
    ./0003-Fix-NixOS-containers.patch
    ./0004-Look-for-fsck-in-the-right-place.patch
    ./0005-Add-some-NixOS-specific-unit-directories.patch
    ./0006-Get-rid-of-a-useless-message-in-user-sessions.patch
    ./0007-hostnamed-localed-timedated-disable-methods-that-cha.patch
    ./0008-Fix-hwdb-paths.patch
    ./0009-Change-usr-share-zoneinfo-to-etc-zoneinfo.patch
    ./0010-localectl-use-etc-X11-xkb-for-list-x11.patch
    ./0011-build-don-t-create-statedir-and-don-t-touch-prefixdi.patch
    ./0012-Install-default-configuration-into-out-share-factory.patch
    ./0013-inherit-systemd-environment-when-calling-generators.patch
    ./0014-add-rootprefix-to-lookup-dir-paths.patch
    ./0015-systemd-shutdown-execute-scripts-in-etc-systemd-syst.patch
    ./0016-systemd-sleep-execute-scripts-in-etc-systemd-system-.patch
    ./0017-kmod-static-nodes.service-Update-ConditionFileNotEmp.patch
    ./0018-path-util.h-add-placeholder-for-DEFAULT_PATH_NORMAL.patch
    ./0019-revert-get-rid-of-seat_can_multi_session.patch
  ];

  postPatch = ''
    substituteInPlace src/basic/path-util.h --replace "@defaultPathNormal@" "${placeholder "out"}/bin/"
    substituteInPlace src/boot/efi/meson.build \
      --replace \
      "find_program('ld'" \
      "find_program('${stdenv.cc.bintools.targetPrefix}ld'" \
      --replace \
      "find_program('objcopy'" \
      "find_program('${stdenv.cc.bintools.targetPrefix}objcopy'"
  '';

  outputs = [ "out" "man" "dev" ];

  nativeBuildInputs =
    [ pkgconfig intltool gperf libxslt gettext docbook_xsl docbook_xml_dtd_42 docbook_xml_dtd_45
      ninja meson
      coreutils # meson calls date, stat etc.
      glibcLocales
      patchelf getent m4
      perl # to patch the libsystemd.so and remove dependencies on aarch64

      (buildPackages.python3Packages.python.withPackages ( ps: with ps; [ python3Packages.lxml ]))
    ];
  buildInputs =
    [ linuxHeaders libcap curl.dev kmod xz pam acl
      cryptsetup libuuid glib libgcrypt libgpgerror libidn2
      libmicrohttpd pcre2 ] ++
      stdenv.lib.optional withKexectools kexectools ++
      stdenv.lib.optional withLibseccomp libseccomp ++
    [ libffi audit lz4 bzip2 libapparmor
      iptables gnu-efi
    ] ++ stdenv.lib.optional withSelinux libselinux;

  #dontAddPrefix = true;

  mesonFlags = [
    "-Ddbuspolicydir=${placeholder "out"}/share/dbus-1/system.d"
    "-Ddbussessionservicedir=${placeholder "out"}/share/dbus-1/services"
    "-Ddbussystemservicedir=${placeholder "out"}/share/dbus-1/system-services"
    "-Dpamconfdir=${placeholder "out"}/etc/pam.d"
    "-Drootprefix=${placeholder "out"}"
    "-Dpkgconfiglibdir=${placeholder "dev"}/lib/pkgconfig"
    "-Dpkgconfigdatadir=${placeholder "dev"}/share/pkgconfig"
    "-Dloadkeys-path=${kbd}/bin/loadkeys"
    "-Dsetfont-path=${kbd}/bin/setfont"
    "-Dtty-gid=3" # tty in NixOS has gid 3
    "-Ddebug-shell=${bashInteractive}/bin/bash"
    # while we do not run tests we should also not build them. Removes about 600 targets
    "-Dtests=false"
    "-Dimportd=true"
    "-Dlz4=true"
    "-Dhomed=false"
    "-Dhostnamed=true"
    "-Dnetworkd=true"
    "-Dportabled=false"
    "-Dremote=true"
    "-Dsysusers=false"
    "-Dtimedated=true"
    "-Dtimesyncd=true"
    "-Dfirstboot=false"
    "-Dlocaled=true"
    "-Dresolve=true"
    "-Dsplit-usr=false"
    "-Dlibcurl=true"
    "-Dlibidn=false"
    "-Dlibidn2=true"
    "-Dquotacheck=false"
    "-Dldconfig=false"
    "-Dsmack=true"
    "-Db_pie=true"
    /*
    As of now, systemd doesn't allow runtime configuration of these values. So
    the settings in /etc/login.defs have no effect on it. Many people think this
    should be supported however, see
    - https://github.com/systemd/systemd/issues/3855
    - https://github.com/systemd/systemd/issues/4850
    - https://github.com/systemd/systemd/issues/9769
    - https://github.com/systemd/systemd/issues/9843
    - https://github.com/systemd/systemd/issues/10184
    */
    "-Dsystem-uid-max=999"
    "-Dsystem-gid-max=999"
    # "-Dtime-epoch=1"

    (if !stdenv.hostPlatform.isEfi then "-Dgnu-efi=false" else "-Dgnu-efi=true")
    "-Defi-libdir=${toString gnu-efi}/lib"
    "-Defi-includedir=${toString gnu-efi}/include/efi"
    "-Defi-ldsdir=${toString gnu-efi}/lib"

    "-Dsysvinit-path="
    "-Dsysvrcnd-path="

    "-Dkill-path=${coreutils}/bin/kill"
    "-Dkmod-path=${kmod}/bin/kmod"
    "-Dsulogin-path=${utillinux}/bin/sulogin"
    "-Dmount-path=${utillinux}/bin/mount"
    "-Dumount-path=${utillinux}/bin/umount"
    "-Dcreate-log-dirs=false"
    # Upstream uses cgroupsv2 by default. To support docker and other
    # container managers we still need v1.
    "-Ddefault-hierarchy=hybrid"
    # Upstream defaulted to disable manpages since they optimize for the much
    # more frequent development builds
    "-Dman=true"
  ];

  preConfigure = ''
    mesonFlagsArray+=(-Dntp-servers="0.nixos.pool.ntp.org 1.nixos.pool.ntp.org 2.nixos.pool.ntp.org 3.nixos.pool.ntp.org")
    export LC_ALL="en_US.UTF-8";
    # FIXME: patch this in systemd properly (and send upstream).
    # already fixed in f00929ad622c978f8ad83590a15a765b4beecac9: (u)mount
    for i in \
      src/core/mount.c \
      src/core/swap.c \
      src/cryptsetup/cryptsetup-generator.c \
      src/fsck/fsck.c \
      src/journal/cat.c \
      src/nspawn/nspawn.c \
      src/remount-fs/remount-fs.c \
      src/shared/generator.c \
      src/shutdown/shutdown.c \
      units/emergency.service.in \
      units/rescue.service.in \
      units/systemd-logind.service.in \
      units/systemd-nspawn@.service.in; \
    do
      test -e $i
      substituteInPlace $i \
        --replace /usr/bin/getent ${getent}/bin/getent \
        --replace /sbin/mkswap ${lib.getBin utillinux}/sbin/mkswap \
        --replace /sbin/swapon ${lib.getBin utillinux}/sbin/swapon \
        --replace /sbin/swapoff ${lib.getBin utillinux}/sbin/swapoff \
        --replace /sbin/mke2fs ${lib.getBin e2fsprogs}/sbin/mke2fs \
        --replace /sbin/fsck ${lib.getBin utillinux}/sbin/fsck \
        --replace /bin/echo ${coreutils}/bin/echo \
        --replace /bin/cat ${coreutils}/bin/cat \
        --replace /sbin/sulogin ${lib.getBin utillinux}/sbin/sulogin \
        --replace /sbin/modprobe ${lib.getBin kmod}/sbin/modprobe \
        --replace /usr/lib/systemd/systemd-fsck $out/lib/systemd/systemd-fsck \
        --replace /bin/plymouth /run/current-system/sw/bin/plymouth # To avoid dependency
    done

    for dir in tools src/resolve test src/test; do
      patchShebangs $dir
    done

    # absolute paths to gpg & tar
    substituteInPlace src/import/pull-common.c \
      --replace '"gpg"' '"${gnupg}/bin/gpg"'
    for file in src/import/{{export,import,pull}-tar,import-common}.c; do
      substituteInPlace $file \
        --replace '"tar"' '"${gnutar}/bin/tar"'
    done

    substituteInPlace src/journal/catalog.c \
      --replace /usr/lib/systemd/catalog/ $out/lib/systemd/catalog/
  '';

  # These defines are overridden by CFLAGS and would trigger annoying
  # warning messages
  postConfigure = ''
    substituteInPlace config.h \
      --replace "POLKIT_AGENT_BINARY_PATH" "_POLKIT_AGENT_BINARY_PATH" \
      --replace "SYSTEMD_BINARY_PATH" "_SYSTEMD_BINARY_PATH" \
      --replace "SYSTEMD_CGROUP_AGENT_PATH" "_SYSTEMD_CGROUP_AGENT_PATH"
  '';

  NIX_CFLAGS_COMPILE = toString [
    # Can't say ${polkit.bin}/bin/pkttyagent here because that would
    # lead to a cyclic dependency.
    "-UPOLKIT_AGENT_BINARY_PATH" "-DPOLKIT_AGENT_BINARY_PATH=\"/run/current-system/sw/bin/pkttyagent\""

    # Set the release_agent on /sys/fs/cgroup/systemd to the
    # currently running systemd (/run/current-system/systemd) so
    # that we don't use an obsolete/garbage-collected release agent.
    "-USYSTEMD_CGROUP_AGENT_PATH" "-DSYSTEMD_CGROUP_AGENT_PATH=\"/run/current-system/systemd/lib/systemd/systemd-cgroups-agent\""

    "-USYSTEMD_BINARY_PATH" "-DSYSTEMD_BINARY_PATH=\"/run/current-system/systemd/lib/systemd/systemd\""
  ];

  doCheck = false; # fails a bunch of tests

  # trigger the test -n "$DESTDIR" || mutate in upstreams build system
  preInstall = ''
    export DESTDIR=/
  '';

  postInstall = ''
    # sysinit.target: Don't depend on
    # systemd-tmpfiles-setup.service. This interferes with NixOps's
    # send-keys feature (since sshd.service depends indirectly on
    # sysinit.target).
    mv $out/lib/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup-dev.service $out/lib/systemd/system/multi-user.target.wants/

    mkdir -p $out/example/systemd
    mv $out/lib/{modules-load.d,binfmt.d,sysctl.d,tmpfiles.d} $out/example
    mv $out/lib/systemd/{system,user} $out/example/systemd

    rm -rf $out/etc/systemd/system

    # Fix reference to /bin/false in the D-Bus services.
    for i in $out/share/dbus-1/system-services/*.service; do
      substituteInPlace $i --replace /bin/false ${coreutils}/bin/false
    done

    rm -rf $out/etc/rpm

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

  meta = with stdenv.lib; {
    homepage = "https://www.freedesktop.org/wiki/Software/systemd/";
    description = "A system and service manager for Linux";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    priority = 10;
    maintainers = with maintainers; [ andir eelco flokli ];
  };
}
