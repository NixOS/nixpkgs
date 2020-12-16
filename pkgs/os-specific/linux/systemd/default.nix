{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, buildPackages
, ninja
, meson
, m4
, pkgconfig
, coreutils
, gperf
, getent
, patchelf
, glibcLocales
, glib
, substituteAll
, gettext
, python3Packages

  # Mandatory dependencies
, libcap
, util-linux
, kbd
, kmod

  # Optional dependencies
, pam
, cryptsetup
, lvm2
, audit
, acl
, lz4
, libgcrypt
, libgpgerror
, libidn2
, curl
, gnutar
, gnupg
, zlib
, xz
, libuuid
, libapparmor
, intltool
, bzip2
, pcre2
, e2fsprogs
, linuxHeaders ? stdenv.cc.libc.linuxHeaders
, gnu-efi
, iptables
, withSelinux ? false
, libselinux
, withLibseccomp ? lib.any (lib.meta.platformMatch stdenv.hostPlatform) libseccomp.meta.platforms
, libseccomp
, withKexectools ? lib.any (lib.meta.platformMatch stdenv.hostPlatform) kexectools.meta.platforms
, kexectools
, bashInteractive
, libmicrohttpd

, withAnalyze ? true
, withApparmor ? true
, withCompression ? true  # adds bzip2, lz4 and xz
, withCoredump ? true
, withCryptsetup ? true
, withDocumentation ? true
, withEfi ? stdenv.hostPlatform.isEfi
, withHomed ? false
, withHostnamed ? true
, withHwdb ? true
, withImportd ? true
, withLocaled ? true
, withLogind ? true
, withMachined ? true
, withNetworkd ? true
, withNss ? true
, withOomd ? false
, withPCRE2 ? true
, withPolkit ? true
, withPortabled ? false
, withRemote ? true
, withResolved ? true
, withShellCompletions ? true
, withTimedated ? true
, withTimesyncd ? true
, withUserDb ? true
, libfido2
, p11-kit

  # name argument
, pname ? "systemd"


, libxslt
, docbook_xsl
, docbook_xml_dtd_42
, docbook_xml_dtd_45
}:

assert withResolved -> (libgcrypt != null && libgpgerror != null);
assert withImportd ->
(curl.dev != null && zlib != null && xz != null && libgcrypt != null
  && gnutar != null && gnupg != null && withCompression);

assert withEfi -> (gnu-efi != null);
assert withRemote -> lib.getDev curl != null;
assert withCoredump -> withCompression;

assert withHomed -> withCryptsetup;

assert withCryptsetup ->
(cryptsetup != null);
let
  wantCurl = withRemote || withImportd;

  version = "247.2";
in
stdenv.mkDerivation {
  inherit version pname;

  # We use systemd/systemd-stable for src, and ship NixOS-specific patches inside nixpkgs directly
  # This has proven to be less error-prone than the previous systemd fork.
  src = fetchFromGitHub {
    owner = "systemd";
    repo = "systemd-stable";
    rev = "v${version}";
    sha256 = "091pwrvxz3gcf80shlp28d6l4gvjzc6pb61v4mwxmk9d71qaq7ry";
  };

  # If these need to be regenerated, `git am path/to/00*.patch` them into a
  # systemd worktree, rebase to the more recent systemd version, and export the
  # patches again via `git format-patch v${version}`.
  # Use `find . -name "*.patch" | sort` to get an up-to-date listing of all patches
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
    ./0012-inherit-systemd-environment-when-calling-generators.patch
    ./0013-add-rootprefix-to-lookup-dir-paths.patch
    ./0014-systemd-shutdown-execute-scripts-in-etc-systemd-syst.patch
    ./0015-systemd-sleep-execute-scripts-in-etc-systemd-system-.patch
    ./0016-kmod-static-nodes.service-Update-ConditionFileNotEmp.patch
    ./0017-path-util.h-add-placeholder-for-DEFAULT_PATH_NORMAL.patch
    ./0018-logind-seat-debus-show-CanMultiSession-again.patch
    ./0019-Revert-pkg-config-prefix-is-not-really-configurable-.patch
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
    [
      pkgconfig
      gperf
      ninja
      meson
      coreutils # meson calls date, stat etc.
      glibcLocales
      patchelf
      getent
      m4

      intltool
      gettext

      libxslt
      docbook_xsl
      docbook_xml_dtd_42
      docbook_xml_dtd_45
      (buildPackages.python3Packages.python.withPackages (ps: with ps; [ python3Packages.lxml ]))
    ];

  buildInputs =
    [
      acl
      audit
      glib
      kmod
      libcap
      libgcrypt
      libidn2
      libuuid
      linuxHeaders
      pam
    ]

    ++ lib.optional withApparmor libapparmor
    ++ lib.optional wantCurl (lib.getDev curl)
    ++ lib.optionals withCompression [ bzip2 lz4 xz ]
    ++ lib.optional withCryptsetup (lib.getDev cryptsetup.dev)
    ++ lib.optional withEfi gnu-efi
    ++ lib.optional withKexectools kexectools
    ++ lib.optional withLibseccomp libseccomp
    ++ lib.optional withNetworkd iptables
    ++ lib.optional withPCRE2 pcre2
    ++ lib.optional withResolved libgpgerror
    ++ lib.optional withSelinux libselinux
    ++ lib.optional withRemote libmicrohttpd
    ++ lib.optionals withHomed [ p11-kit libfido2 ]
  ;

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
    "-Dglib=${lib.boolToString (glib != null)}"
    # while we do not run tests we should also not build them. Removes about 600 targets
    "-Dtests=false"
    "-Danalyze=${lib.boolToString withAnalyze}"
    "-Dgcrypt=${lib.boolToString (libgcrypt != null)}"
    "-Dimportd=${lib.boolToString withImportd}"
    "-Dlz4=${lib.boolToString withCompression}"
    "-Dhomed=${stdenv.lib.boolToString withHomed}"
    "-Dlogind=${lib.boolToString withLogind}"
    "-Dlocaled=${lib.boolToString withLocaled}"
    "-Dhostnamed=${lib.boolToString withHostnamed}"
    "-Dmachined=${lib.boolToString withMachined}"
    "-Dnetworkd=${lib.boolToString withNetworkd}"
    "-Doomd=${lib.boolToString withOomd}"
    "-Dpolkit=${lib.boolToString withPolkit}"
    "-Dcryptsetup=${lib.boolToString withCryptsetup}"
    "-Dportabled=${lib.boolToString withPortabled}"
    "-Dhwdb=${lib.boolToString withHwdb}"
    "-Dremote=${lib.boolToString withRemote}"
    "-Dsysusers=false"
    "-Dtimedated=${lib.boolToString withTimedated}"
    "-Dtimesyncd=${lib.boolToString withTimesyncd}"
    "-Duserdb=${lib.boolToString withUserDb}"
    "-Dcoredump=${lib.boolToString withCoredump}"
    "-Dfirstboot=false"
    "-Dresolve=${lib.boolToString withResolved}"
    "-Dsplit-usr=false"
    "-Dlibcurl=${lib.boolToString wantCurl}"
    "-Dlibidn=false"
    "-Dlibidn2=true"
    "-Dquotacheck=false"
    "-Dldconfig=false"
    "-Dsmack=true"
    "-Db_pie=true"
    "-Dinstall-sysconfdir=false"
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

    "-Dsysvinit-path="
    "-Dsysvrcnd-path="

    "-Dkill-path=${coreutils}/bin/kill"
    "-Dkmod-path=${kmod}/bin/kmod"
    "-Dsulogin-path=${util-linux}/bin/sulogin"
    "-Dmount-path=${util-linux}/bin/mount"
    "-Dumount-path=${util-linux}/bin/umount"
    "-Dcreate-log-dirs=false"

    # Use cgroupsv2. This is already the upstream default, but better be explicit.
    "-Ddefault-hierarchy=unified"
    # Upstream defaulted to disable manpages since they optimize for the much
    # more frequent development builds
    "-Dman=true"

    "-Defi=${lib.boolToString withEfi}"
    "-Dgnu-efi=${lib.boolToString withEfi}"
  ] ++ lib.optionals withEfi [
    "-Defi-libdir=${toString gnu-efi}/lib"
    "-Defi-includedir=${toString gnu-efi}/include/efi"
    "-Defi-ldsdir=${toString gnu-efi}/lib"
  ] ++ lib.optionals (withShellCompletions == false) [
    "-Dbashcompletiondir=no"
    "-Dzshcompletiondir=no"
  ] ++ lib.optionals (!withNss) [
    "-Dnss-myhostname=false"
    "-Dnss-mymachines=false"
    "-Dnss-resolve=false"
    "-Dnss-systemd=false"
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
        --replace /sbin/mkswap ${lib.getBin util-linux}/sbin/mkswap \
        --replace /sbin/swapon ${lib.getBin util-linux}/sbin/swapon \
        --replace /sbin/swapoff ${lib.getBin util-linux}/sbin/swapoff \
        --replace /bin/echo ${coreutils}/bin/echo \
        --replace /bin/cat ${coreutils}/bin/cat \
        --replace /sbin/sulogin ${lib.getBin util-linux}/sbin/sulogin \
        --replace /sbin/modprobe ${lib.getBin kmod}/sbin/modprobe \
        --replace /usr/lib/systemd/systemd-fsck $out/lib/systemd/systemd-fsck \
        --replace /bin/plymouth /run/current-system/sw/bin/plymouth # To avoid dependency
    done

    for dir in tools src/resolve test src/test src/shared; do
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
    "-UPOLKIT_AGENT_BINARY_PATH"
    "-DPOLKIT_AGENT_BINARY_PATH=\"/run/current-system/sw/bin/pkttyagent\""

    # Set the release_agent on /sys/fs/cgroup/systemd to the
    # currently running systemd (/run/current-system/systemd) so
    # that we don't use an obsolete/garbage-collected release agent.
    "-USYSTEMD_CGROUP_AGENT_PATH"
    "-DSYSTEMD_CGROUP_AGENT_PATH=\"/run/current-system/systemd/lib/systemd/systemd-cgroups-agent\""

    "-USYSTEMD_BINARY_PATH"
    "-DSYSTEMD_BINARY_PATH=\"/run/current-system/systemd/lib/systemd/systemd\""
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
  '' + lib.optionalString (!withDocumentation) ''
    rm -rf $out/share/doc
  '';

  enableParallelBuilding = true;

  # The interface version prevents NixOS from switching to an
  # incompatible systemd at runtime.  (Switching across reboots is
  # fine, of course.)  It should be increased whenever systemd changes
  # in a backwards-incompatible way.  If the interface version of two
  # systemd builds is the same, then we can switch between them at
  # runtime; otherwise we can't and we need to reboot.
  passthru.interfaceVersion = 2;

  meta = with lib; {
    homepage = "https://www.freedesktop.org/wiki/Software/systemd/";
    description = "A system and service manager for Linux";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    priority = 10;
    maintainers = with maintainers; [ andir eelco flokli kloenk ];
  };
}
