{ stdenv, lib, fetchFromGitHub, fetchpatch, pkgconfig, intltool, gperf, libcap, kmod
, xz, pam, acl, libuuid, m4, utillinux, libffi
, glib, kbd, libxslt, coreutils, libgcrypt, libgpgerror, libidn2, libapparmor
, audit, lz4, bzip2, libmicrohttpd, pcre2
, linuxHeaders ? stdenv.cc.libc.linuxHeaders
, iptables, gnu-efi
, gettext, docbook_xsl, docbook_xml_dtd_42, docbook_xml_dtd_45
, ninja, meson, mesonBuilder, python3Packages, glibcLocales
, patchelf
, getent
, buildPackages
, withSelinux ? false, libselinux
, withLibseccomp ? lib.any (lib.meta.platformMatch stdenv.hostPlatform) libseccomp.meta.platforms, libseccomp
, withKexectools ? lib.any (lib.meta.platformMatch stdenv.hostPlatform) kexectools.meta.platforms, kexectools
, enableHibernate ? true, enableBacklight ? true, enableRFKill ? true, enableKmod ? true, enableUtmp ? true
}:

let
  pythonLxmlEnv = buildPackages.python3Packages.python.withPackages ( ps: with ps; [ python3Packages.lxml ]);

in stdenv.mkDerivation rec {
  version = "239";
  name = "systemd-${version}";

  # When updating, use https://github.com/systemd/systemd-stable tree, not the development one!
  # Also fresh patches should be cherry-picked from that tree to our current one.
  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "systemd";
    rev = "31859ddd35fc3fa82a583744caa836d356c31d7f";
    sha256 = "1xci0491j95vdjgs397n618zii3sgwnvanirkblqqw6bcvcjvir1";
  };

  patches = lib.optional stdenv.hostPlatform.isMusl [
    ./0001-Add-qsort_r-when-not-available.patch
    ./0002-Add-comparison_fn_t-check.patch
    ./0003-Use-getenv-when-secure-versions-are-not-available.patch
    ./0004-Check-for-printf.h.patch
    ./0005-Check-for-strndupa.patch
    ./0006-Don-t-include-gshadow.h-when-disabled.patch
    ./0007-Don-t-use-GLOB_ALTDIRFUNC.patch
    ./0008-Check-for-FTW_STOP.patch
    ./0009-Avoid-name-overlap-with-ethhdr.patch
    ./0010-Allow-option-to-disable-pid-cache.patch
    ./0011-Include-missing.h-in-uid-range.c.patch
    ./0012-Fix-mount-setup.patch
    ./0013-add-ULONG_LONG_MAX.patch
  ];

  outputs = [ "out" "lib" "man" "dev" ];

  nativeBuildInputs =
    [ pkgconfig intltool gperf libxslt gettext docbook_xsl docbook_xml_dtd_42 docbook_xml_dtd_45
      ninja meson
      glibcLocales
      patchelf getent m4
    ];
  buildInputs =
    [ linuxHeaders libcap.dev xz pam acl
      /* cryptsetup */ libuuid glib libgcrypt libgpgerror libidn2
      libmicrohttpd pcre2 mesonBuilder ] ++
      stdenv.lib.optional withKexectools kexectools ++
      stdenv.lib.optional withLibseccomp libseccomp ++
      stdenv.lib.optional enableKmod kmod ++
    [ libffi audit lz4 bzip2 libapparmor
      iptables gnu-efi
      # This is actually native, but we already pull it from buildPackages
      pythonLxmlEnv
    ] ++ stdenv.lib.optional withSelinux libselinux;

  #dontAddPrefix = true;

  mesonFlags = [
    "-Dloadkeys-path=${kbd}/bin/loadkeys"
    "-Dsetfont-path=${kbd}/bin/setfont"
    "-Dtty-gid=3" # tty in NixOS has gid 3
    # "-Dtests=" # TODO
    "-Dlz4=true"
    "-Dhostnamed=true"
    "-Dnetworkd=true"
    "-Dsysusers=false"
    "-Dtimedated=true"
    "-Dtimesyncd=true"
    "-Dfirstboot=false"
    "-Dlocaled=true"
    "-Dsplit-usr=false"
    "-Dlibcurl=false"
    "-Dlibidn=false"
    "-Dlibidn2=true"
    "-Dquotacheck=false"
    "-Dldconfig=false"
    "-Dsmack=true"
    "-Dsystem-uid-max=499" #TODO: debug why awking around in /etc/login.defs doesn't work
    "-Dsystem-gid-max=499"
    # "-Dtime-epoch=1"

    (if stdenv.isAarch32 || stdenv.isAarch64 || !stdenv.hostPlatform.isEfi then "-Dgnu-efi=false" else "-Dgnu-efi=true")
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
  ] ++ stdenv.lib.optionals stdenv.hostPlatform.isMusl [
          "-Dgshadow=false"
          "-Didn=false"
          "-Dpidcache=false" # musl has no pid cache
          "-Dmyhostname=false" # requires nsswitch
          "-Dnss-systemd=false" # requires nsswitch
          "-Dmachined=false" # requires nsswitch
          "-Dresolve=false" # requires nsswitch
          "-Dportabled=false"
          "-Dtmpfiles=false" # requires irregular globbing
          "-Dtests=false"
       ]
    ++ stdenv.lib.optional (!stdenv.hostPlatform.isMusl) [
          "-Dresolve=true"
    ]
    ++ stdenv.lib.optional (!enableHibernate) "-Dhibernate=false"
    ++ stdenv.lib.optional (!enableBacklight) "-Dbacklight=false"
    ++ stdenv.lib.optional (!enableRFKill) "-Drfkill=false"
    ++ stdenv.lib.optional (!enableKmod) "-Dkmod=false"
    ++ stdenv.lib.optional (!enableUtmp) "-Dutmp=false";

  preConfigure = ''
    mesonFlagsArray+=(-Dntp-servers="0.nixos.pool.ntp.org 1.nixos.pool.ntp.org 2.nixos.pool.ntp.org 3.nixos.pool.ntp.org")
    mesonFlagsArray+=(-Ddbuspolicydir=$out/etc/dbus-1/system.d)
    mesonFlagsArray+=(-Ddbussessionservicedir=$out/share/dbus-1/services)
    mesonFlagsArray+=(-Ddbussystemservicedir=$out/share/dbus-1/system-services)
    mesonFlagsArray+=(-Dpamconfdir=$out/etc/pam.d)
    mesonFlagsArray+=(-Drootprefix=$out)
    mesonFlagsArray+=(-Drootlibdir=$lib/lib)
    mesonFlagsArray+=(-Dpkgconfiglibdir=$dev/lib/pkgconfig)
    mesonFlagsArray+=(-Dpkgconfigdatadir=$dev/share/pkgconfig)

    export LC_ALL="en_US.UTF-8";
    # FIXME: patch this in systemd properly (and send upstream).
    # already fixed in f00929ad622c978f8ad83590a15a765b4beecac9: (u)mount
    for i in src/remount-fs/remount-fs.c src/core/mount.c src/core/swap.c src/fsck/fsck.c units/emergency.service.in units/rescue.service.in src/journal/cat.c src/core/shutdown.c src/nspawn/nspawn.c src/shared/generator.c; do
      test -e $i
      substituteInPlace $i \
        --replace /usr/bin/getent ${getent}/bin/getent \
        --replace /sbin/swapon ${utillinux.bin}/sbin/swapon \
        --replace /sbin/swapoff ${utillinux.bin}/sbin/swapoff \
        --replace /sbin/fsck ${utillinux.bin}/sbin/fsck \
        --replace /bin/echo ${coreutils}/bin/echo \
        --replace /bin/cat ${coreutils}/bin/cat \
        --replace /sbin/sulogin ${utillinux.bin}/sbin/sulogin \
        --replace /usr/lib/systemd/systemd-fsck $out/lib/systemd/systemd-fsck \
        --replace /bin/plymouth /run/current-system/sw/bin/plymouth # To avoid dependency
    done

    for i in tools/xml_helper.py tools/make-directive-index.py tools/make-man-index.py test/sys-script.py; do
      substituteInPlace $i \
        --replace "#!/usr/bin/env python" "#!${pythonLxmlEnv}/bin/python"
    done

    for i in src/basic/generate-gperfs.py src/resolve/generate-dns_type-gperf.py src/test/generate-sym-test.py ; do
      substituteInPlace $i \
        --replace "#!/usr/bin/env python" "#!${buildPackages.python3Packages.python}/bin/python"
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
    ${stdenv.lib.optionalString (!stdenv.hostPlatform.isMusl) "mv $out/lib/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup-dev.service $out/lib/systemd/system/multi-user.target.wants/"}

    mkdir -p $out/example/systemd
    mv $out/lib/{binfmt.d,sysctl.d} $out/example
    ${stdenv.lib.optionalString (!stdenv.hostPlatform.isMusl) "mv $out/lib/tmpfiles.d $out/example"}
    ${stdenv.lib.optionalString enableKmod "mv $out/lib/modules-load.d $out/example"}
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
    maintainers = [ maintainers.eelco ];
  };
}
