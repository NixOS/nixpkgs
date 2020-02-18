{ stdenv, lib, fetchFromGitHub, fetchpatch, pkgconfig, intltool, gperf, libcap, kmod
, xz, pam, acl, libuuid, m4, utillinux, libffi
, glib, kbd, libxslt, coreutils, libgcrypt, libgpgerror, libidn2, libapparmor
, audit, lz4, bzip2, libmicrohttpd, pcre2
, linuxHeaders ? stdenv.cc.libc.linuxHeaders
, iptables, gnu-efi
, gettext, docbook_xsl, docbook_xml_dtd_42, docbook_xml_dtd_45
, ninja, meson, python3Packages, glibcLocales
, patchelf
, getent
, buildPackages
, perl
, withSelinux ? false, libselinux
, withLibseccomp ? lib.any (lib.meta.platformMatch stdenv.hostPlatform) libseccomp.meta.platforms, libseccomp
, withKexectools ? lib.any (lib.meta.platformMatch stdenv.hostPlatform) kexectools.meta.platforms, kexectools
}:

let
  pythonLxmlEnv = buildPackages.python3Packages.python.withPackages ( ps: with ps; [ python3Packages.lxml ]);

in stdenv.mkDerivation {
  version = "243.7";
  pname = "systemd";

  # When updating, use https://github.com/systemd/systemd-stable tree, not the development one!
  # Also fresh patches should be cherry-picked from that tree to our current one.
  src = fetchFromGitHub {
    owner = "nixos";
    repo = "systemd";
    rev = "e7d881488292fc8bdf96acd12767eca1bd65adae";
    sha256 = "0haj3iff3y13pm4w5dbqj1drp5wryqfad58jbbmnb6zdgis56h8f";
  };

  outputs = [ "out" "lib" "man" "dev" ];

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
    [ linuxHeaders libcap kmod xz pam acl
      /* cryptsetup */ libuuid glib libgcrypt libgpgerror libidn2
      libmicrohttpd pcre2 ] ++
      stdenv.lib.optional withKexectools kexectools ++
      stdenv.lib.optional withLibseccomp libseccomp ++
    [ libffi audit lz4 bzip2 libapparmor
      iptables gnu-efi
    ] ++ stdenv.lib.optional withSelinux libselinux;

  #dontAddPrefix = true;

  mesonFlags = [
    "-Ddbuspolicydir=${placeholder "out"}/etc/dbus-1/system.d"
    "-Ddbussessionservicedir=${placeholder "out"}/share/dbus-1/services"
    "-Ddbussystemservicedir=${placeholder "out"}/share/dbus-1/system-services"
    "-Dpamconfdir=${placeholder "out"}/etc/pam.d"
    "-Drootprefix=${placeholder "out"}"
    "-Drootlibdir=${placeholder "lib"}/lib"
    "-Dpkgconfiglibdir=${placeholder "dev"}/lib/pkgconfig"
    "-Dpkgconfigdatadir=${placeholder "dev"}/share/pkgconfig"
    "-Dloadkeys-path=${kbd}/bin/loadkeys"
    "-Dsetfont-path=${kbd}/bin/setfont"
    "-Dtty-gid=3" # tty in NixOS has gid 3
    # while we do not run tests we should also not build them. Removes about 600 targets
    "-Dtests=false"
    "-Dlz4=true"
    "-Dhostnamed=true"
    "-Dnetworkd=true"
    "-Dsysusers=false"
    "-Dtimedated=true"
    "-Dtimesyncd=true"
    "-Dfirstboot=false"
    "-Dlocaled=true"
    "-Dresolve=true"
    "-Dsplit-usr=false"
    "-Dlibcurl=false"
    "-Dlibidn=false"
    "-Dlibidn2=true"
    "-Dquotacheck=false"
    "-Dldconfig=false"
    "-Dsmack=true"
    "-Db_pie=true"
    "-Dsystem-uid-max=499" #TODO: debug why awking around in /etc/login.defs doesn't work
    "-Dsystem-gid-max=499"
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
    for i in src/remount-fs/remount-fs.c src/core/mount.c src/core/swap.c src/fsck/fsck.c units/emergency.service.in units/rescue.service.in src/journal/cat.c src/shutdown/shutdown.c src/nspawn/nspawn.c src/shared/generator.c; do
      test -e $i
      substituteInPlace $i \
        --replace /usr/bin/getent ${getent}/bin/getent \
        --replace /sbin/swapon ${lib.getBin utillinux}/sbin/swapon \
        --replace /sbin/swapoff ${lib.getBin utillinux}/sbin/swapoff \
        --replace /sbin/fsck ${lib.getBin utillinux}/sbin/fsck \
        --replace /bin/echo ${coreutils}/bin/echo \
        --replace /bin/cat ${coreutils}/bin/cat \
        --replace /sbin/sulogin ${lib.getBin utillinux}/sbin/sulogin \
        --replace /usr/lib/systemd/systemd-fsck $out/lib/systemd/systemd-fsck \
        --replace /bin/plymouth /run/current-system/sw/bin/plymouth # To avoid dependency
    done

    for dir in tools src/resolve test src/test; do
      patchShebangs $dir
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
    mv $lib/lib/security $lib/lib/libnss* $out/lib/
  ''; # */

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
    homepage = "https://www.freedesktop.org/wiki/Software/systemd/";
    description = "A system and service manager for Linux";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    priority = 10;
    maintainers = with maintainers; [ eelco andir mic92 ];
  };
}
