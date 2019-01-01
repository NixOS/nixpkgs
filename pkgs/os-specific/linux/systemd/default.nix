{ stdenv, lib, fetchFromGitHub, fetchpatch, fetchurl, pkgconfig, intltool, gperf, libcap, kmod
, libuuid, m4, utillinux, libffi
, kbd, coreutils
, linuxHeaders ? stdenv.cc.libc.linuxHeaders
, gettext
, ninja, meson, python3Packages, glibcLocales
, patchelf
, getent
, buildPackages

# dependencies for optional features
, acl
, audit
, bzip2
, cryptsetup
, curl
, dbus_libs
, docbook_xml_dtd_42
, docbook_xml_dtd_45
, docbook_xsl
, elfutils
, glib
, gnu-efi
, gnutls
, iptables
, libapparmor
, libgcrypt
, libgpgerror
, libidn
, libidn2
, libmicrohttpd
, libseccomp
, libselinux
, libxkbcommon
, libxslt
, lz4
, pam
, pcre2
, polkit
, qrencode
, xz
, zlib

, features ? {}
, withSelinux ? false
, withLibseccomp ? lib.any (lib.meta.platformMatch stdenv.hostPlatform) libseccomp.meta.platforms
, withKexectools ? lib.any (lib.meta.platformMatch stdenv.hostPlatform) kexectools.meta.platforms, kexectools
}:

let
  pythonLxmlEnv = buildPackages.python3Packages.python.withPackages ( ps: with ps; [ python3Packages.lxml ]);

  # Runtime features that depend on additional packages. Initial list
  # constructed by running:
  #   meson build
  #   cd build
  #   meson configure | sed -n '
  #     1,/^Project options:/d;
  #     /Testing options:/q;
  #     s/^ *\([^ ]*\).*\[.*auto.*\].*/\1/p'
  # and then checking which dependency checks corresponded to each feature in
  # meson.build.
  allFeatures = metaFeatures ++ (lib.attrNames (featureBuildInputs // featureNativeBuildInputs));

  featureBuildInputs = {
    "acl" = [ acl ];
    "apparmor" = [ libapparmor ];
    "audit" = [ audit ];
    "blkid" = [ utillinux ];
    "bzip2" = [ bzip2 ];
    "dbus" = [ dbus_libs ];
    "elfutils" = [ elfutils ];
    "gcrypt" = [ libgcrypt libgpgerror ];
    "glib" = [ glib ];
    "gnu-efi" = [ gnu-efi ]; # requires "efi" and maybe "efi-*" features also
    "gnutls" = [ gnutls ];
    "kmod" = [ kmod ];
    "libcryptsetup" = [ cryptsetup ];
    "libcurl" = [ curl ];
    "libidn" = [ libidn ];
    "libidn2" = [ libidn2 ];
    "libiptc" = [ iptables ];
    "lz4" = [ lz4 ];
    "microhttpd" = [ libmicrohttpd ];
    "pam" = [ pam ];
    "pcre2" = [ pcre2 ];
    "qrencode" = [ qrencode ];
    "seccomp" = [ libseccomp ];
    "selinux" = [ libselinux ];
    "xkbcommon" = [ libxkbcommon ];
    "xz" = [ xz ];
    "zlib" = [ zlib ];
  };

  featureNativeBuildInputs = {
    "html" = [ libxslt.bin docbook_xsl docbook_xml_dtd_42 docbook_xml_dtd_45 ];
    "man" = [ libxslt.bin docbook_xsl docbook_xml_dtd_42 docbook_xml_dtd_45 pythonLxmlEnv ];
  };

  metaFeatures = [
    "dns-over-tls" # requires "gnutls" feature as well
    "importd" # requires "libcurl", "zlib", "xz", and "gcrypt" features also
    "polkit" # if polkit package is present, there's a build-time version check
    "remote" # requires "microhttpd" and "libcurl" features also
    "split-bin"
    "split-usr"
  ];

  # Disable all features that have dependencies, then turn back on the features
  # that NixOS wants.
  defaultFeatures = lib.genAttrs allFeatures (_: false) //
    {
      # Features systemd would try to auto-detect that we want turned on:
      "acl" = true;
      "apparmor" = true;
      "audit" = true;
      "blkid" = true;
      "bzip2" = true;
      "gcrypt" = true;
      "glib" = true;
      "gnu-efi" = !stdenv.isAarch32 && !stdenv.isAarch64 && stdenv.hostPlatform.isEfi;
      "kmod" = true;
      "libidn2" = true;
      "libiptc" = true;
      "lz4" = true;
      "man" = true;
      "microhttpd" = true;
      "pam" = true;
      "pcre2" = true;
      "polkit" = true;
      "remote" = "auto"; # only way to get sd-j-remote without sd-j-upload
      "seccomp" = withLibseccomp;
      "selinux" = withSelinux;
      "split-bin" = true;
      "xz" = true;
      "zlib" = true;

      # Other flags:
      "tests" = false; # TODO: fails a bunch of tests
      "hostnamed" = true;
      "networkd" = true;
      "sysusers" = false;
      "timedated" = true;
      "timesyncd" = true;
      "firstboot" = false;
      "localed" = true;
      "resolve" = true;
      "quotacheck" = false;
      "ldconfig" = false;
      "smack" = true;

      # NixOS-specific settings, overridable if desired:
      "tty-gid" = 3; # tty in NixOS has gid 3
      "system-uid-max" = 499; #TODO: debug why awking around in /etc/login.defs doesn't work
      "system-gid-max" = 499;
      "ntp-servers" = "0.nixos.pool.ntp.org 1.nixos.pool.ntp.org 2.nixos.pool.ntp.org 3.nixos.pool.ntp.org";
      # "time-epoch" = 1;

      # NixOS doesn't need SysV init compatibility.
      "sysvinit-path" = "";
      "sysvrcnd-path" = "";

      # Needed if the gnu-efi feature is enabled; ignored otherwise.
      "efi-includedir" = "${toString gnu-efi}/include/efi";
      "efi-ldsdir" = "${toString gnu-efi}/lib";
      "efi-libdir" = "${toString gnu-efi}/lib";

      # Paths to binaries that systemd invokes:
      "kill-path" = "${coreutils}/bin/kill";
      "loadkeys-path" = "${kbd}/bin/loadkeys";
      "setfont-path" = "${kbd}/bin/setfont";
      "kmod-path" = "${kmod}/bin/kmod";
      "sulogin-path" = "${utillinux}/bin/sulogin";
      "mount-path" = "${utillinux}/bin/mount";
      "umount-path" = "${utillinux}/bin/umount";
    };

  finalFeatures = defaultFeatures // features;

  enabledFeature = name: let v = finalFeatures.${name}; in v != false && v != "false";

  getDeps = avail: lib.concatLists (lib.mapAttrsToList (name: deps: lib.optionals (enabledFeature name) deps) avail);

  featureFlag = name: value:
    let v =
      if lib.isBool value then if value then "true" else "false"
      else toString value;
    in "-D${name}=${v}";

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

  prePatch = let
      # Upstream's maintenance branches are still too intrusive:
      # https://github.com/systemd/systemd-stable/tree/v239-stable
      patches-deb = fetchurl {
        # When the URL disappears, it typically means that Debian has new patches
        # (probably security) and updating to new tarball will apply them as well.
        name = "systemd-debian-patches.tar.xz";
        url = mirror://debian/pool/main/s/systemd/systemd_239-11~bpo9+1.debian.tar.xz;
        sha256 = "136f6p4jbi4z94mf4g099dfcacwka8jwhza0wxxw2q5l5q3xiysh";
      };
      # Note that we skip debian-specific patches, i.e. ./debian/patches/debian/*
    in ''
      tar xf ${patches-deb}
      patches="$patches $(cat debian/patches/series | grep -v '^debian/' | sed 's|^|debian/patches/|')"
    '';

  outputs = [ "out" "lib" "dev" ] ++
    lib.optional (enabledFeature "man") "man";

  nativeBuildInputs =
    [ pkgconfig intltool gperf gettext
      ninja meson
      coreutils # meson calls date, stat etc.
      glibcLocales
      patchelf getent m4
    ] ++ getDeps featureNativeBuildInputs;

  buildInputs =
    [ linuxHeaders libcap libuuid libffi ] ++
    getDeps featureBuildInputs ++
    stdenv.lib.optional withKexectools kexectools;

  #dontAddPrefix = true;

  # Passing either mesonFlags or mesonFlagsArray via the environment makes it
  # very difficult to preserve flags which might contain whitespace or shell
  # special characters, so we use bash syntax to set mesonFlagsArray instead.
  preConfigure = ''
    mesonFlagsArray+=(${lib.concatStringsSep " " [
      (lib.escapeShellArgs (lib.mapAttrsToList featureFlag finalFeatures))
      "-Ddbuspolicydir=$out/etc/dbus-1/system.d"
      "-Ddbussessionservicedir=$out/share/dbus-1/services"
      "-Ddbussystemservicedir=$out/share/dbus-1/system-services"
      "-Dpamconfdir=$out/etc/pam.d"
      "-Dpkgconfigdatadir=$dev/share/pkgconfig"
      "-Dpkgconfiglibdir=$dev/lib/pkgconfig"
      "-Drootlibdir=$lib/lib"
      "-Drootprefix=$out"
    ]})

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

    if meson configure | grep ' auto ' | grep -v '^ *remote '; then
      echo "The above features should be explicitly set. Aborting."
      exit 1
    fi
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

  doCheck = enabledFeature "tests";

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

  # The interface version prevents NixOS from switching to an
  # incompatible systemd at runtime.  (Switching across reboots is
  # fine, of course.)  It should be increased whenever systemd changes
  # in a backwards-incompatible way.  If the interface version of two
  # systemd builds is the same, then we can switch between them at
  # runtime; otherwise we can't and we need to reboot.
  passthru.interfaceVersion = 2;

  passthru.features = finalFeatures;

  meta = with stdenv.lib; {
    homepage = http://www.freedesktop.org/wiki/Software/systemd;
    description = "A system and service manager for Linux";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.eelco ];
  };
}
