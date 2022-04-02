# NOTE: Make sure to (re-)format this file on changes with `nixpkgs-fmt`!

{ stdenv
, lib
, nixosTests
, fetchFromGitHub
, fetchpatch
, fetchzip
, buildPackages
, ninja
, meson
, m4
, pkg-config
, coreutils
, gperf
, getent
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
, libgpg-error
, libidn2
, curl
, gnutar
, gnupg
, zlib
, xz
, zstd
, tpm2-tss
, libuuid
, libapparmor
, intltool
, bzip2
, pcre2
, e2fsprogs
, elfutils
, linuxHeaders ? stdenv.cc.libc.linuxHeaders
, gnu-efi
, iptables
, withSelinux ? false
, libselinux
, withLibseccomp ? lib.meta.availableOn stdenv.hostPlatform libseccomp
, libseccomp
, withKexectools ? lib.meta.availableOn stdenv.hostPlatform kexec-tools
, kexec-tools
, bashInteractive
, libmicrohttpd

  # the (optional) BPF feature requires bpftool, libbpf, clang and llmv-strip to be avilable during build time.
  # Only libbpf should be a runtime dependency.
, bpftools
, libbpf
, llvmPackages

, withAnalyze ? true
, withApparmor ? true
, withCompression ? true  # adds bzip2, lz4, xz and zstd
, withCoredump ? true
, withCryptsetup ? true
, withDocumentation ? true
, withEfi ? stdenv.hostPlatform.isEfi
, withFido2 ? true
, withHomed ? false
, withHostnamed ? true
, withHwdb ? true
, withImportd ? !stdenv.hostPlatform.isMusl
, withLibBPF ? false # currently fails while generating BPF objects
, withLocaled ? true
, withLogind ? true
, withMachined ? true
, withNetworkd ? true
, withNss ? !stdenv.hostPlatform.isMusl
, withOomd ? false
, withPCRE2 ? true
, withPolkit ? true
, withPortabled ? false
, withRemote ? !stdenv.hostPlatform.isMusl
, withResolved ? true
, withShellCompletions ? true
, withTimedated ? true
, withTimesyncd ? true
, withTpm2Tss ? !stdenv.hostPlatform.isMusl
, withUserDb ? !stdenv.hostPlatform.isMusl
, libfido2
, p11-kit

  # name argument
, pname ? "systemd"

, libxslt
, docbook_xsl
, docbook_xml_dtd_42
, docbook_xml_dtd_45
}:

assert withResolved -> (libgcrypt != null && libgpg-error != null);
assert withImportd ->
(curl.dev != null && zlib != null && xz != null && libgcrypt != null
  && gnutar != null && gnupg != null && withCompression);

assert withEfi -> (gnu-efi != null);
assert withRemote -> lib.getDev curl != null;
assert withCoredump -> withCompression;

assert withHomed -> withCryptsetup;

assert withCryptsetup -> (cryptsetup != null);
let
  wantCurl = withRemote || withImportd;
  version = "249.7";
in
stdenv.mkDerivation {
  inherit pname version;

  # We use systemd/systemd-stable for src, and ship NixOS-specific patches inside nixpkgs directly
  # This has proven to be less error-prone than the previous systemd fork.
  src = fetchFromGitHub {
    owner = "systemd";
    repo = "systemd-stable";
    rev = "v${version}";
    sha256 = "sha256-y33/BvvI+JyhsvuT1Cbm6J2Z72j71oXgLw6X9NwCMPE=";
  };

  # If these need to be regenerated, `git am path/to/00*.patch` them into a
  # systemd worktree, rebase to the more recent systemd version, and export the
  # patches again via `git -c format.signoff=false format-patch v${version}`.
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
    ./0018-pkg-config-derive-prefix-from-prefix.patch

    # In v248 or v249 we started to get in trouble due to our
    # /etc/systemd/system being a symlink and thus being treated differently by
    # systemd. With the below patch we mitigate that effect by special casing
    # all our root unit dirs if they are symlinks. This does exactly what we
    # need (AFAICT).
    # See https://github.com/systemd/systemd/pull/20479 for upsteam discussion.
    ./0019-core-handle-lookup-paths-being-symlinks.patch
  ] ++ lib.optional stdenv.hostPlatform.isMusl (let
    oe-core = fetchzip {
      url = "https://git.openembedded.org/openembedded-core/snapshot/openembedded-core-14c6e5a4b72d0e4665279158a0740dd1dc21f72f.tar.bz2";
      sha256 = "1jixya4czkr5p5rdcw3d6ips8zzr82dvnanvzvgjh67730scflya";
    };
    musl-patches = oe-core + "/meta/recipes-core/systemd/systemd";
  in [
    (musl-patches + "/0002-don-t-use-glibc-specific-qsort_r.patch")
    (musl-patches + "/0003-missing_type.h-add-__compare_fn_t-and-comparison_fn_.patch")
    (musl-patches + "/0004-add-fallback-parse_printf_format-implementation.patch")
    (musl-patches + "/0005-src-basic-missing.h-check-for-missing-strndupa.patch")
    (musl-patches + "/0006-Include-netinet-if_ether.h.patch")
    (musl-patches + "/0007-don-t-fail-if-GLOB_BRACE-and-GLOB_ALTDIRFUNC-is-not-.patch")
    (musl-patches + "/0008-add-missing-FTW_-macros-for-musl.patch")
    (musl-patches + "/0009-fix-missing-of-__register_atfork-for-non-glibc-build.patch")
    (musl-patches + "/0010-Use-uintmax_t-for-handling-rlim_t.patch")
    (musl-patches + "/0011-test-sizeof.c-Disable-tests-for-missing-typedefs-in-.patch")
    (musl-patches + "/0012-don-t-pass-AT_SYMLINK_NOFOLLOW-flag-to-faccessat.patch")
    (musl-patches + "/0013-Define-glibc-compatible-basename-for-non-glibc-syste.patch")
    (musl-patches + "/0014-Do-not-disable-buffering-when-writing-to-oom_score_a.patch")
    (musl-patches + "/0015-distinguish-XSI-compliant-strerror_r-from-GNU-specif.patch")
    (musl-patches + "/0016-Hide-__start_BUS_ERROR_MAP-and-__stop_BUS_ERROR_MAP.patch")
    (musl-patches + "/0017-missing_type.h-add-__compar_d_fn_t-definition.patch")
    (musl-patches + "/0018-avoid-redefinition-of-prctl_mm_map-structure.patch")
    (musl-patches + "/0019-Handle-missing-LOCK_EX.patch")
    (musl-patches + "/0021-test-json.c-define-M_PIl.patch")
    (musl-patches + "/0022-do-not-disable-buffer-in-writing-files.patch")
    (musl-patches + "/0025-Handle-__cpu_mask-usage.patch")
    (musl-patches + "/0026-Handle-missing-gshadow.patch")
    (musl-patches + "/0028-missing_syscall.h-Define-MIPS-ABI-defines-for-musl.patch")

    # Being discussed upstream: https://lists.openembedded.org/g/openembedded-core/topic/86411771#157056
    ./musl.diff
  ]);

  postPatch = ''
    substituteInPlace src/basic/path-util.h --replace "@defaultPathNormal@" "${placeholder "out"}/bin/"
    substituteInPlace src/boot/efi/meson.build \
      --replace \
      "find_program('objcopy'" \
      "find_program('${stdenv.cc.bintools.targetPrefix}objcopy'"
  '' + (
    let
      # The folllowing patches references to dynamic libraries to ensure that
      # all the features that are implemented via dlopen(3) are available (or
      # explicitly deactivated) by pointing dlopen to the absolute store path
      # instead of relying on the linkers runtime lookup code.
      #
      # All of the shared library references have to be handled. When new ones
      # are introduced by upstream (or one of our patches) they must be
      # explicitly declared, otherwise the build will fail.
      #
      # As of systemd version 247 we've seen a few errors like `libpcre2.… not
      # found` when using e.g. --grep with journalctl. Those errors should
      # become less unexpected now.
      #
      # There are generally two classes of dlopen(3) calls. Those that we want to
      # support and those that should be deactivated / unsupported. This change
      # enforces that we handle all dlopen calls explicitly. Meaning: There is
      # not a single dlopen call in the source code tree that we did not
      # explicitly handle.
      #
      # In order to do this we introduced a list of attributes that maps from
      # shared object name to the package that contains them. The package can be
      # null meaning the reference should be nuked and the shared object will
      # never be loadable during runtime (because it points at an invalid store
      # path location).
      #
      # To get a list of dynamically loaded libraries issue something like
      # `grep -ri '"lib[a-zA-Z0-9-]*\.so[\.0-9a-zA-z]*"'' $src` and update the below list.
      dlopenLibs =
        let
          opt = condition: pkg: if condition then pkg else null;
        in
        [
          # bpf compilation support
          { name = "libbpf.so.0"; pkg = opt withLibBPF libbpf; }

          # We did never provide support for libxkbcommon & qrencode
          { name = "libxkbcommon.so.0"; pkg = null; }
          { name = "libqrencode.so.4"; pkg = null; }

          # We did not provide libpwquality before so it is safe to disable it for
          # now.
          { name = "libpwquality.so.1"; pkg = null; }

          # Only include cryptsetup if it is enabled. We might not be able to
          # provide it during "bootstrap" in e.g. the minimal systemd build as
          # cryptsetup has udev (aka systemd) in it's dependencies.
          { name = "libcryptsetup.so.12"; pkg = opt withCryptsetup cryptsetup; }

          # We are using libidn2 so we only provide that and ignore the others.
          # Systemd does this decision during configure time and uses ifdef's to
          # enable specific branches. We can safely ignore (nuke) the libidn "v1"
          # libraries.
          { name = "libidn2.so.0"; pkg = libidn2; }
          { name = "libidn.so.12"; pkg = null; }
          { name = "libidn.so.11"; pkg = null; }

          # journalctl --grep requires libpcre so lets provide it
          { name = "libpcre2-8.so.0"; pkg = pcre2; }

          # Support for TPM2 in systemd-cryptsetup, systemd-repart and systemd-cryptenroll
          { name = "libtss2-esys.so.0"; pkg = opt withTpm2Tss tpm2-tss; }
          { name = "libtss2-rc.so.0"; pkg = opt withTpm2Tss tpm2-tss; }
          { name = "libtss2-mu.so.0"; pkg = opt withTpm2Tss tpm2-tss; }
          { name = "libtss2-tcti-"; pkg = opt withTpm2Tss tpm2-tss; }
          { name = "libfido2.so.1"; pkg = opt withFido2 libfido2; }
        ];

      patchDlOpen = dl:
        let
          library = "${lib.makeLibraryPath [ dl.pkg ]}/${dl.name}";
        in
        if dl.pkg == null then ''
          # remove the dependency on the library by replacing it with an invalid path
          for file in $(grep -lr '"${dl.name}"' src); do
            echo "patching dlopen(\"${dl.name}\", …) in $file to an invalid store path ("/nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-not-implemented/${dl.name}")…"
            substituteInPlace "$file" --replace '"${dl.name}"' '"/nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-not-implemented/${dl.name}"'
          done
        '' else ''
          # ensure that the library we provide actually exists
          if ! [ -e ${library} ]; then
            # exceptional case, details:
            # https://github.com/systemd/systemd-stable/blob/v249-stable/src/shared/tpm2-util.c#L157
            if ! [[ "${library}" =~ .*libtss2-tcti-$ ]]; then
              echo 'The shared library `${library}` does not exist but was given as subtitute for `${dl.name}`'
              exit 1
            fi
          fi
          # make the path to the dependency explicit
          for file in $(grep -lr '"${dl.name}"' src); do
            echo "patching dlopen(\"${dl.name}\", …) in $file to ${library}…"
            substituteInPlace "$file" --replace '"${dl.name}"' '"${library}"'
          done

        '';
    in
    # patch all the dlopen calls to contain absolute paths to the libraries
    lib.concatMapStringsSep "\n" patchDlOpen dlopenLibs
  )
  # finally ensure that there are no left-over dlopen calls (or rather strings pointing to shared libraries) that we didn't handle
  + ''
    if grep -qr '"lib[a-zA-Z0-9-]*\.so[\.0-9a-zA-z]*"' src; then
      echo "Found unhandled dynamic library calls: "
      grep -r '"lib[a-zA-Z0-9-]*\.so[\.0-9a-zA-z]*"' src
      exit 1
    fi
  ''
  # Finally patch shebangs that might need patching.
  # Should no longer be necessary with v250.
  # https://github.com/systemd/systemd/pull/19638
  + ''
    patchShebangs .
  '';

  outputs = [ "out" "man" "dev" ];

  nativeBuildInputs =
    [
      pkg-config
      gperf
      ninja
      meson
      glibcLocales
      getent
      m4

      intltool
      gettext

      libxslt
      docbook_xsl
      docbook_xml_dtd_42
      docbook_xml_dtd_45
      (buildPackages.python3Packages.python.withPackages (ps: with ps; [ lxml jinja2 ]))
    ]
    ++ lib.optional withLibBPF [
      bpftools
      llvmPackages.clang
      llvmPackages.libllvm
    ]
  ;

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
    ++ lib.optionals withCompression [ bzip2 lz4 xz zstd ]
    ++ lib.optional withCoredump elfutils
    ++ lib.optional withCryptsetup (lib.getDev cryptsetup.dev)
    ++ lib.optional withEfi gnu-efi
    ++ lib.optional withKexectools kexec-tools
    ++ lib.optional withLibseccomp libseccomp
    ++ lib.optional withNetworkd iptables
    ++ lib.optional withPCRE2 pcre2
    ++ lib.optional withResolved libgpg-error
    ++ lib.optional withSelinux libselinux
    ++ lib.optional withRemote libmicrohttpd
    ++ lib.optionals withHomed [ p11-kit ]
    ++ lib.optionals (withHomed || withCryptsetup) [ libfido2 ]
    ++ lib.optionals withLibBPF [ libbpf ]
    ++ lib.optional withTpm2Tss tpm2-tss
  ;

  #dontAddPrefix = true;

  mesonFlags = [
    "-Dversion-tag=${version}"
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
    "-Dhomed=${lib.boolToString withHomed}"
    "-Dlogind=${lib.boolToString withLogind}"
    "-Dlocaled=${lib.boolToString withLocaled}"
    "-Dhostnamed=${lib.boolToString withHostnamed}"
    "-Dmachined=${lib.boolToString withMachined}"
    "-Dnetworkd=${lib.boolToString withNetworkd}"
    "-Doomd=${lib.boolToString withOomd}"
    "-Dpolkit=${lib.boolToString withPolkit}"
    "-Dlibcryptsetup=${lib.boolToString withCryptsetup}"
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
    "-Defi-ld=${stdenv.cc.bintools.targetPrefix}ld"
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
  ] ++ lib.optionals (withShellCompletions == false) [
    "-Dbashcompletiondir=no"
    "-Dzshcompletiondir=no"
  ] ++ lib.optionals (!withNss) [
    "-Dnss-myhostname=false"
    "-Dnss-mymachines=false"
    "-Dnss-resolve=false"
    "-Dnss-systemd=false"
  ] ++ lib.optionals withLibBPF [
    "-Dbpf-framework=true"
  ] ++ lib.optionals withTpm2Tss [
    "-Dtpm2=true"
  ] ++ lib.optionals stdenv.hostPlatform.isMusl [
    "-Dgshadow=false"
    "-Dutmp=false"
    "-Didn=false"
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
      units/modprobe@.service \
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


    substituteInPlace src/libsystemd/sd-journal/catalog.c \
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

  NIX_CFLAGS_COMPILE = toString ([
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

  ] ++ lib.optionals stdenv.hostPlatform.isMusl [
    "-D__UAPI_DEF_ETHHDR=0"
  ]);

  doCheck = false; # fails a bunch of tests

  # trigger the test -n "$DESTDIR" || mutate in upstreams build system
  preInstall = ''
    export DESTDIR=/
  '';

  postInstall = ''
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

  passthru = {
    # The interface version prevents NixOS from switching to an
    # incompatible systemd at runtime.  (Switching across reboots is
    # fine, of course.)  It should be increased whenever systemd changes
    # in a backwards-incompatible way.  If the interface version of two
    # systemd builds is the same, then we can switch between them at
    # runtime; otherwise we can't and we need to reboot.
    interfaceVersion = 2;

    inherit withCryptsetup;

    tests = {
      inherit (nixosTests) switchTest;
    };
  };

  meta = with lib; {
    homepage = "https://www.freedesktop.org/wiki/Software/systemd/";
    description = "A system and service manager for Linux";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    priority = 10;
    maintainers = with maintainers; [ flokli kloenk mic92 ];
  };
}
