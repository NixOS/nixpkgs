{ stdenv, lib, fetchFromGitHub, fetchpatch
, buildPackages
, ninja, meson, m4, pkgconfig, coreutils, gperf, getent
, patchelf, perl, glibcLocales

, gettext

# Mandatory dependencies
, libcap
, utillinux
, kbd
, kmod

# Optional dependencies
, pam, /*cryptsetup,*/ audit, acl, libselinux
, lz4, libgcrypt, libgpgerror, libmicrohttpd, libidn2
, curl, gnutar, gnupg, zlib
, xz, libuuid, libffi
, libapparmor
, bzip2, pcre2
, linuxHeaders ? stdenv.cc.libc.linuxHeaders
, gnu-efi
, iptables

, withLibseccomp ? lib.any (lib.meta.platformMatch stdenv.hostPlatform) libseccomp.meta.platforms, libseccomp
, withKexectools ? lib.any (lib.meta.platformMatch stdenv.hostPlatform) kexectools.meta.platforms, kexectools

, withResolved ? true
, withLogind ? true
, withHostnamed ? true
, withLocaled ? true
, withNetworkd ? true
, withTimedated ? true
, withTimesyncd ? true
, withHwdb ? true
, withEfi ? stdenv.hostPlatform.isEfi
, withImportd ? true

, bashInteractive

, libxslt, docbook_xsl, docbook_xml_dtd_42, docbook_xml_dtd_45
}:

assert withResolved -> (libgcrypt != null && libgpgerror != null);
assert withImportd ->
  ( curl.dev != null && zlib != null && xz != null && libgcrypt != null
 && gnutar != null && gnupg != null);

let
  trueFalse = cond: if cond then "true" else "false";

  gnupg-minimal = gnupg.override {
    enableMinimal = true;
    guiSupport = false;
    pcsclite = null;
    sqlite = null;
    pinentry = null;
    adns = null;
    gnutls = null;
    libusb = null;
    openldap = null;
    readline = null;
    zlib = null;
    bzip2 = null;
  };
in

stdenv.mkDerivation {
  version = "243";
  pname = "systemd";

  # When updating, use https://github.com/systemd/systemd-stable tree, not the development one!
  # Also fresh patches should be cherry-picked from that tree to our current one.
  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "systemd";
    rev = "d25cf413c6bff1b5a9d216a8830e3a90c9cad1de";
    sha256 = "0ilvrnh3m7g0yflxl16fk52gkb1z0fwwk9ba5gs4005nzpl0c7i0";
  };

  outputs = [ "out" "lib" "man" "dev" ];

  nativeBuildInputs =
    [ pkgconfig gperf
      ninja meson
      coreutils # meson calls date, stat etc.
      glibcLocales
      patchelf getent m4
      perl # to patch the libsystemd.so and remove dependencies on aarch64

      gettext

      libxslt docbook_xsl docbook_xml_dtd_42 docbook_xml_dtd_45
    ] ++ [
      (buildPackages.python3Packages.python.withPackages
        (ps: [ ps.lxml ])
      )
    ]
    ;
  buildInputs =
    [ linuxHeaders libcap curl.dev kmod xz pam acl
      /* cryptsetup */ libuuid stdenv.cc.libc libgcrypt libgpgerror libidn2
      utillinux libmicrohttpd pcre2 ] ++
      lib.optional withKexectools kexectools ++
      lib.optional withLibseccomp libseccomp ++
    [ libffi audit lz4 bzip2 libapparmor libselinux iptables
    ] ++ lib.optional withEfi gnu-efi;

  #dontAddPrefix = true;

  mesonFlags = [
    "-Db_pie=true"

    "-Drootprefix=${placeholder "out"}"
    "-Drootlibdir=${placeholder "lib"}/lib"
    "-Dsplit-usr=false"

    "-Dsysvinit-path="
    "-Dsysvrcnd-path="
    "-Drc-local="

    "-Dkmod-path=${kmod}/bin/kmod"
    "-Dsulogin-path=${utillinux}/bin/sulogin"
    "-Dmount-path=${utillinux}/bin/mount"
    "-Dumount-path=${utillinux}/bin/umount"

    "-Dloadkeys-path=${kbd}/bin/loadkeys"
    "-Dsetfont-path=${kbd}/bin/setfont"
    "-Dtty-gid=3" # tty in NixOS has gid 3
    "-Ddebug-shell=${bashInteractive}/bin/bash"

    "-Ddbuspolicydir=${placeholder "out"}/share/dbus-1/system.d"
    "-Ddbussessionservicedir=${placeholder "out"}/share/dbus-1/services"
    "-Ddbussystemservicedir=${placeholder "out"}/share/dbus-1/system-services"
    "-Dpamconfdir=no"
    "-Dpkgconfiglibdir=${placeholder "dev"}/lib/pkgconfig"
    "-Dpkgconfigdatadir=${placeholder "dev"}/share/pkgconfig"
    # while we do not run tests we should also not build them. Removes about 600 targets
    "-Dtests=false"

    "-Dresolve=${trueFalse withResolved}"
    "-Dlogind=${trueFalse withLogind}"
    "-Dhostnamed=${trueFalse withHostnamed}"
    "-Dlocaled=${trueFalse withLocaled}"
    "-Dnetworkd=${trueFalse withNetworkd}"
    "-Dtimedated=${trueFalse withTimedated}"
    "-Dtimesyncd=${trueFalse withTimesyncd}"
    "-Dfirstboot=false"
    "-Dquotacheck=false"
    "-Dsysusers=false"
    "-Dhwdb=${trueFalse withHwdb}"
    "-Dldconfig=false"
    "-Dsmack=true"

    "-Dimportd=${trueFalse withImportd}"

    "-Dlibcurl=${trueFalse (curl.dev != null)}"
    "-Dlibidn=false"
    "-Dlibidn2=${trueFalse (libidn2 != null)}"
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

    "-Defi=${trueFalse withEfi}"
    "-Dgnu-efi=${trueFalse (withEfi && gnu-efi != null)}"
  ] ++ lib.optionals (withEfi && gnu-efi != null) [
    "-Defi-libdir=${gnu-efi}/lib"
    "-Defi-includedir=${gnu-efi}/include/efi"
    "-Defi-ldsdir=${gnu-efi}/lib"

  ] ++ [
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
    for i in src/remount-fs/remount-fs.c src/core/mount.c src/core/swap.c src/fsck/fsck.c units/emergency.service.in units/rescue.service.in src/journal/cat.c src/shutdown/shutdown.c src/nspawn/nspawn.c src/shared/generator.c units/systemd-logind.service.in units/systemd-nspawn@.service.in; do
      test -e $i
      substituteInPlace $i \
        --replace /usr/bin/getent ${getent}/bin/getent \
        --replace /sbin/swapon ${lib.getBin utillinux}/sbin/swapon \
        --replace /sbin/swapoff ${lib.getBin utillinux}/sbin/swapoff \
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

  '' + lib.optionalString withImportd ''
    # absolute paths to gpg & tar
    substituteInPlace src/import/pull-common.c \
      --replace '"gpg"' '"${gnupg-minimal}/bin/gpg"'
    for file in src/import/{{export,import,pull}-tar,import-common}.c; do
      substituteInPlace $file \
        --replace '"tar"' '"${gnutar}/bin/tar"'
    done

  '' + ''
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

  NIX_CFLAGS_COMPILE =
    [ # Can't say ${polkit.bin}/bin/pkttyagent here because that would
      # lead to a cyclic dependency.
      "-UPOLKIT_AGENT_BINARY_PATH" "-DPOLKIT_AGENT_BINARY_PATH=\"/run/current-system/sw/bin/pkttyagent\""

      # Set the release_agent on /sys/fs/cgroup/systemd to the
      # currently running systemd (/run/current-system/systemd) so
      # that we don't use an obsolete/garbage-collected release agent.
      "-USYSTEMD_CGROUP_AGENT_PATH" "-DSYSTEMD_CGROUP_AGENT_PATH=\"/run/current-system/systemd/lib/systemd/systemd-cgroups-agent\""

      "-USYSTEMD_BINARY_PATH" "-DSYSTEMD_BINARY_PATH=\"/run/current-system/systemd/lib/systemd/systemd\""
    ];

  doCheck = false; # fails a bunch of tests

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

    # Keep only libudev and libsystemd in the lib output.
    mkdir -p $out/lib
    mv $lib/lib/libnss* $out/lib/
  '' + lib.optionalString (pam != null) ''
    mv $lib/lib/security $out/lib/
  '';

  enableParallelBuilding = true;

  # On aarch64 we "leak" a reference to $out/lib/systemd/catalog in the lib
  # output. The result of that is a dependency cycle between $out and $lib.
  # Thus nix (rightfully) marks the build as failed. That reference originates
  # from an array of strings (catalog_file_dirs) in systemd
  # (src/src/journal/catalog.{c,h}).  The only consumer (as of v242) of the
  # symbol is the main function of journalctl.  Still libsystemd.so contains
  # the VALUE but not the symbol.  Systemd seems to be properly using function
  # & data sections together with the linker flags to garbage collect unused
  # sections (-Wl,--gc-sections).  For unknown reasons those flags do not
  # eliminate the unused string constants, in this case on aarch64-linux. The
  # hacky way is to just remove the reference after we finished compiling.
  # Since it can not be used (there is no symbol to actually refer to it) there
  # should not be any harm.  It is a bit odd and I really do not like starting
  # these kind of hacks but there doesn't seem to be a straight forward way at
  # this point in time.
  # The reference will be replaced by the same reference the usual nukeRefs
  # tooling uses.  The standard tooling can not / should not be uesd since it
  # is a bit too excessive and could potentially do us some (more) harm.
  postFixup = ''
    nukedRef=$(echo $out | sed -e "s,$NIX_STORE/[^-]*-\(.*\),$NIX_STORE/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-\1,")
    cat $lib/lib/libsystemd.so | perl -pe "s|$out/lib/systemd/catalog|$nukedRef/lib/systemd/catalog|" > $lib/lib/libsystemd.so.tmp
    mv $lib/lib/libsystemd.so.tmp $(readlink -f $lib/lib/libsystemd.so)
  '';

  # The interface version prevents NixOS from switching to an
  # incompatible systemd at runtime.  (Switching across reboots is
  # fine, of course.)  It should be increased whenever systemd changes
  # in a backwards-incompatible way.  If the interface version of two
  # systemd builds is the same, then we can switch between them at
  # runtime; otherwise we can't and we need to reboot.
  passthru.interfaceVersion = 2;

  meta = with stdenv.lib; {
    homepage = http://www.freedesktop.org/wiki/Software/systemd;
    description = "A system and service manager for Linux";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    priority = 10;
    maintainers = with maintainers; [ eelco andir mic92 ];
  };
}
