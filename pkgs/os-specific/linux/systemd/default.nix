{
  stdenv,
  lib,
  nixosTests,
  pkgsCross,
  testers,
  fetchFromGitHub,
  fetchzip,
  buildPackages,
  makeBinaryWrapper,
  ninja,
  meson,
  m4,
  pkg-config,
  coreutils,
  gperf,
  getent,
  glibcLocales,
  autoPatchelfHook,
  fetchpatch,

  # glib is only used during tests (test-bus-gvariant, test-bus-marshal)
  glib,
  gettext,
  python3Packages,

  # Mandatory dependencies
  libcap,
  util-linux,
  kbd,
  kmod,
  libxcrypt,

  # Optional dependencies
  pam,
  cryptsetup,
  audit,
  acl,
  lz4,
  openssl,
  libgcrypt,
  libgpg-error,
  libidn2,
  curl,
  gnutar,
  gnupg,
  zlib,
  xz,
  zstd,
  tpm2-tss,
  libuuid,
  libapparmor,
  intltool,
  bzip2,
  pcre2,
  elfutils,
  linuxHeaders ? stdenv.cc.libc.linuxHeaders,
  gnutls,
  iptables,
  withSelinux ? false,
  libselinux,
  withLibseccomp ? lib.meta.availableOn stdenv.hostPlatform libseccomp,
  libseccomp,
  withKexectools ? lib.meta.availableOn stdenv.hostPlatform kexec-tools,
  kexec-tools,
  bash,
  bashNonInteractive,
  libmicrohttpd,
  libfido2,
  p11-kit,
  libpwquality,
  qrencode,
  libarchive,
  llvmPackages,

  # the (optional) BPF feature requires bpftool, libbpf, clang and llvm-strip to
  # be available during build time.
  # Only libbpf should be a runtime dependency.
  # Note: llvmPackages is explicitly taken from buildPackages instead of relying
  # on splicing. Splicing will evaluate the adjacent (pkgsHostTarget) llvmPackages
  # which is sometimes problematic: llvmPackages.clang looks at targetPackages.stdenv.cc
  # which, in the unfortunate case of pkgsCross.ghcjs, `throw`s. If we
  # explicitly take buildPackages.llvmPackages, this is no problem because
  # `buildPackages.targetPackages.stdenv.cc == stdenv.cc` relative to
  # us. Working around this is important, because systemd is in the dependency
  # closure of GHC via emscripten and jdk.
  bpftools,
  libbpf,

  # Needed to produce a ukify that works for cross compiling UKIs.
  targetPackages,

  withAcl ? true,
  withAnalyze ? true,
  withApparmor ? true,
  withAudit ? true,
  # compiles systemd-boot, assumes EFI is available.
  withBootloader ?
    withEfi
    && !stdenv.hostPlatform.isMusl
    # "Unknown 64-bit data model"
    && !stdenv.hostPlatform.isRiscV32,
  # adds bzip2, lz4, xz and zstd
  withCompression ? true,
  withCoredump ? true,
  withCryptsetup ? true,
  withRepart ? true,
  withDocumentation ? true,
  withEfi ? stdenv.hostPlatform.isEfi,
  withFido2 ? true,
  withFirstboot ? true,
  withGcrypt ? true,
  withHomed ? !stdenv.hostPlatform.isMusl,
  withHostnamed ? true,
  withHwdb ? true,
  withImportd ? !stdenv.hostPlatform.isMusl,
  withKmod ? true,
  withLibBPF ?
    lib.versionAtLeast buildPackages.llvmPackages.clang.version "10.0"
    # assumes hard floats
    && (
      stdenv.hostPlatform.isAarch
      ->
        stdenv.hostPlatform.parsed.cpu ? version
        && lib.versionAtLeast stdenv.hostPlatform.parsed.cpu.version "6"
    )
    # see https://github.com/NixOS/nixpkgs/pull/194149#issuecomment-1266642211
    && !stdenv.hostPlatform.isMips64
    # https://reviews.llvm.org/D43106#1019077
    && (stdenv.hostPlatform.isRiscV32 -> stdenv.cc.isClang)
    # buildPackages.targetPackages.llvmPackages is the same as llvmPackages,
    # but we do it this way to avoid taking llvmPackages as an input, and
    # risking making it too easy to ignore the above comment about llvmPackages.
    && lib.meta.availableOn stdenv.hostPlatform buildPackages.targetPackages.llvmPackages.compiler-rt,
  withLibidn2 ? true,
  withLocaled ? true,
  withLogind ? true,
  withMachined ? true,
  withNetworkd ? true,
  withNspawn ? !buildLibsOnly,
  withNss ? !stdenv.hostPlatform.isMusl,
  withOomd ? true,
  withOpenSSL ? true,
  withPam ? true,
  withPasswordQuality ? true,
  withPCRE2 ? true,
  withPolkit ? true,
  withPortabled ? !stdenv.hostPlatform.isMusl,
  withQrencode ? true,
  withRemote ? !stdenv.hostPlatform.isMusl,
  withResolved ? true,
  withShellCompletions ? true,
  withSysusers ? true,
  withSysupdate ? true,
  withTimedated ? true,
  withTimesyncd ? true,
  withTpm2Tss ? true,
  # adds python to closure which is too much by default
  withUkify ? false,
  withUserDb ? true,
  withUtmp ? !stdenv.hostPlatform.isMusl,
  withVmspawn ? true,
  # kernel-install shouldn't usually be used on NixOS, but can be useful, e.g. for
  # building disk images for non-NixOS systems. To save users from trying to use it
  # on their live NixOS system, we disable it by default.
  withKernelInstall ? false,
  withLibarchive ? true,
  # tests assume too much system access for them to be feasible for us right now
  withTests ? false,
  # build only libudev and libsystemd
  buildLibsOnly ? false,

  # yes, pname is an argument here
  pname ? "systemd",

  libxslt,
  docbook_xsl,
  docbook_xml_dtd_42,
  docbook_xml_dtd_45,
  withLogTrace ? false,
}:

assert withImportd -> withCompression;
assert withCoredump -> withCompression;
assert withHomed -> withCryptsetup;
assert withHomed -> withPam;
assert withHomed -> withOpenSSL;
assert withFido2 -> withOpenSSL;
assert withSysupdate -> withOpenSSL;
assert withImportd -> (withGcrypt || withOpenSSL);
assert withUkify -> (withEfi && withBootloader);
assert withRepart -> withCryptsetup;
assert withBootloader -> withEfi;

let
  wantCurl = withRemote || withImportd;

  version = "257.8";

  # Use the command below to update `releaseTimestamp` on every (major) version
  # change. More details in the commentary at mesonFlags.
  # command:
  #  $ curl -s https://api.github.com/repos/systemd/systemd/releases/latest | \
  #     jq '.created_at|strptime("%Y-%m-%dT%H:%M:%SZ")|mktime'
  releaseTimestamp = "1734643670";

  kbd' = if withPam then kbd else kbd.override { withVlock = false; };
in
stdenv.mkDerivation (finalAttrs: {
  inherit pname version;

  # We use systemd/systemd-stable for src, and ship NixOS-specific patches inside nixpkgs directly
  # This has proven to be less error-prone than the previous systemd fork.
  src = fetchFromGitHub {
    owner = "systemd";
    repo = "systemd";
    rev = "v${version}";
    hash = "sha256-XQ+IyRar74qQij96CKClHXW0kkPnGeKUgA8ULiWh5YY=";
  };

  # On major changes, or when otherwise required, you *must* :
  # 1. reformat the patches,
  # 2. `git am path/to/00*.patch` them into a systemd worktree,
  # 3. rebase to the more recent systemd version,
  # 4. and export the patches again via
  #   `git -c format.signoff=false format-patch v${version} --no-numbered --zero-commit --no-signature`.
  # Use `find . -name "*.patch" | sort` to get an up-to-date listing of all
  # patches
  patches = [
    ./0001-Start-device-units-for-uninitialised-encrypted-devic.patch
    ./0002-Don-t-try-to-unmount-nix-or-nix-store.patch
    ./0003-Fix-NixOS-containers.patch
    ./0004-Add-some-NixOS-specific-unit-directories.patch
    ./0005-Get-rid-of-a-useless-message-in-user-sessions.patch
    ./0006-hostnamed-localed-timedated-disable-methods-that-cha.patch
    ./0007-Change-usr-share-zoneinfo-to-etc-zoneinfo.patch
    ./0008-localectl-use-etc-X11-xkb-for-list-x11.patch
    ./0009-add-rootprefix-to-lookup-dir-paths.patch
    ./0010-systemd-shutdown-execute-scripts-in-etc-systemd-syst.patch
    ./0011-systemd-sleep-execute-scripts-in-etc-systemd-system-.patch
    ./0012-path-util.h-add-placeholder-for-DEFAULT_PATH_NORMAL.patch
    ./0013-inherit-systemd-environment-when-calling-generators.patch
    ./0014-core-don-t-taint-on-unmerged-usr.patch
    ./0015-tpm2_context_init-fix-driver-name-checking.patch
    ./0016-systemctl-edit-suggest-systemdctl-edit-runtime-on-sy.patch
    ./0017-meson.build-do-not-create-systemdstatedir.patch

    # systemd tries to link the systemd-ssh-proxy ssh config snippet with tmpfiles
    # if the install prefix is not /usr, but that does not work for us
    # because we include the config snippet manually
    ./0018-meson-Don-t-link-ssh-dropins.patch

    ./0019-install-unit_file_exists_full-follow-symlinks.patch
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isGnu) [
    ./0020-timesyncd-disable-NSCD-when-DNSSEC-validation-is-dis.patch
  ]
  ++ lib.optionals (stdenv.hostPlatform.isPower64) [
    # Auto-detect ELF ABI instead of hardcoding ELFv2 for BPF build
    # Fixes targeting ELFv1
    # https://github.com/systemd/systemd/pull/38307#issuecomment-3120543119
    (fetchpatch {
      name = "0101-systemd-meson.build-Detect-ELF-ABI-version-for-bpf-build-on-ppc64.patch";
      url = "https://github.com/systemd/systemd/commit/f9509192512a4c4b9e3915a096333d4b6b297956.patch";
      hash = "sha256-OGUw+hRCKZm+1EcR64M67QJ9c/PbS2Lk/A+1B3q4Jzs=";
    })
  ]
  ++ lib.optionals stdenv.hostPlatform.isMusl (
    let
      # NOTE: the master-next branch does not have stable URLs.
      # If we need patches that aren't in master yet, they'll have to be
      # vendored.
      oe-core = fetchzip {
        url = "https://git.openembedded.org/openembedded-core/snapshot/openembedded-core-4891f47cdaf919033bf1c02cc12e4805e5db99a0.tar.gz";
        hash = "sha256-YKL/oC+rPZ2EEVNidEV+pJihZgUv7vLb0OASplgktn4=";
      };
    in
    map (patch: "${oe-core}/meta/recipes-core/systemd/systemd/${patch}") [
      "0003-missing_type.h-add-comparison_fn_t.patch"
      "0004-add-fallback-parse_printf_format-implementation.patch"
      "0005-don-t-fail-if-GLOB_BRACE-and-GLOB_ALTDIRFUNC-is-not-.patch"
      "0006-add-missing-FTW_-macros-for-musl.patch"
      "0007-Use-uintmax_t-for-handling-rlim_t.patch"
      "0008-Define-glibc-compatible-basename-for-non-glibc-syste.patch"
      "0009-Do-not-disable-buffering-when-writing-to-oom_score_a.patch"
      "0010-distinguish-XSI-compliant-strerror_r-from-GNU-specif.patch"
      "0011-avoid-redefinition-of-prctl_mm_map-structure.patch"
      "0012-do-not-disable-buffer-in-writing-files.patch"
      "0013-Handle-__cpu_mask-usage.patch"
      "0014-Handle-missing-gshadow.patch"
      "0015-missing_syscall.h-Define-MIPS-ABI-defines-for-musl.patch"
      "0016-pass-correct-parameters-to-getdents64.patch"
      "0017-Adjust-for-musl-headers.patch"
      "0018-test-bus-error-strerror-is-assumed-to-be-GNU-specifi.patch"
      "0019-errno-util-Make-STRERROR-portable-for-musl.patch"
      "0020-sd-event-Make-malloc_trim-conditional-on-glibc.patch"
      "0021-shared-Do-not-use-malloc_info-on-musl.patch"
      "0022-avoid-missing-LOCK_EX-declaration.patch"
      "0023-include-signal.h-to-avoid-the-undeclared-error.patch"
      "0024-undef-stdin-for-references-using-stdin-as-a-struct-m.patch"
      "0025-adjust-header-inclusion-order-to-avoid-redeclaration.patch"
      "0026-build-path.c-avoid-boot-time-segfault-for-musl.patch"
    ]
    ++ [
      # add a missing include
      (fetchpatch {
        url = "https://github.com/systemd/systemd/commit/34fcd3638817060c79e1186b370e46d9b3a7409f.patch";
        hash = "sha256-Uaewo3jPrZGJttlLcqO6cCj1w3IGZmvbur4+TBdIPxc=";
        excludes = [ "src/udev/udevd.c" ];
      })
    ]
  );

  postPatch = ''
    substituteInPlace src/basic/path-util.h --replace "@defaultPathNormal@" "${placeholder "out"}/bin/"
  ''
  + lib.optionalString withLibBPF ''
    substituteInPlace meson.build \
      --replace "find_program('clang'" "find_program('${stdenv.cc.targetPrefix}clang'"
  ''
  + lib.optionalString withUkify ''
    substituteInPlace src/ukify/ukify.py \
      --replace \
      "'readelf'" \
      "'${targetPackages.stdenv.cc.bintools.targetPrefix}readelf'" \
      --replace \
      "/usr/lib/systemd/boot/efi" \
      "$out/lib/systemd/boot/efi"
  ''
  # Finally, patch shebangs in scripts used at build time. This must not patch
  # scripts that will end up in the output, to avoid build platform references
  # when cross-compiling.
  + ''
    shopt -s extglob
    patchShebangs tools test src/!(rpm|kernel-install|ukify) src/kernel-install/test-kernel-install.sh
  '';

  outputs = [
    "out"
    "dev"
  ]
  ++ (lib.optional (!buildLibsOnly) "man");
  separateDebugInfo = true;
  __structuredAttrs = true;

  hardeningDisable = [
    # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=111523
    "trivialautovarinit"
  ]
  ++ (lib.optionals withLibBPF [
    # breaks clang -target bpf; should be fixed to not use
    # a wrapped clang?
    "zerocallusedregs"
    "shadowstack"
    "pacret"
  ]);

  nativeBuildInputs = [
    pkg-config
    makeBinaryWrapper
    gperf
    ninja
    meson
    glibcLocales
    m4
    autoPatchelfHook

    intltool
    gettext

    libxslt
    docbook_xsl
    docbook_xml_dtd_42
    docbook_xml_dtd_45
    bash
    (buildPackages.python3Packages.python.withPackages (
      ps:
      with ps;
      [
        lxml
        jinja2
      ]
      ++ lib.optional withEfi ps.pyelftools
    ))
  ]
  ++ lib.optionals withLibBPF [
    bpftools
    buildPackages.llvmPackages.clang
    buildPackages.llvmPackages.libllvm
  ];

  autoPatchelfFlags = [ "--keep-libc" ];

  buildInputs = [
    libxcrypt
    (if withPam then libcap else libcap.override { usePam = false; })
    libuuid
    linuxHeaders
  ]

  ++ lib.optionals withGcrypt [
    libgcrypt
    libgpg-error
  ]
  ++ lib.optionals withOpenSSL [ openssl ]
  ++ lib.optional withTests glib
  ++ lib.optional withAcl acl
  ++ lib.optional withApparmor libapparmor
  ++ lib.optional withAudit audit
  ++ lib.optional wantCurl (lib.getDev curl)
  ++ lib.optionals withCompression [
    zlib
    bzip2
    lz4
    xz
    zstd
  ]
  ++ lib.optional withCoredump elfutils
  ++ lib.optional withCryptsetup (lib.getDev cryptsetup.dev)
  ++ lib.optional withKexectools kexec-tools
  ++ lib.optional withKmod kmod
  ++ lib.optional withLibidn2 libidn2
  ++ lib.optional withLibseccomp libseccomp
  ++ lib.optional withPam pam
  ++ lib.optional withPCRE2 pcre2
  ++ lib.optional withSelinux libselinux
  ++ lib.optionals withRemote [
    libmicrohttpd
    gnutls
  ]
  ++ lib.optionals (withHomed || withCryptsetup) [ p11-kit ]
  ++ lib.optionals (withHomed || withCryptsetup) [ libfido2 ]
  ++ lib.optionals withLibBPF [ libbpf ]
  ++ lib.optional withTpm2Tss tpm2-tss
  ++ lib.optional withUkify (python3Packages.python.withPackages (ps: with ps; [ pefile ]))
  ++ lib.optionals withPasswordQuality [ libpwquality ]
  ++ lib.optionals withQrencode [ qrencode ]
  ++ lib.optionals withLibarchive [ libarchive ]
  ++ lib.optional (withBootloader && stdenv.targetPlatform.useLLVM or false) (
    llvmPackages.compiler-rt.override {
      doFakeLibgcc = true;
    }
  );

  mesonBuildType = "release";

  mesonFlags = [
    # Options

    # We bump this attribute on every (major) version change to ensure that we
    # have known-good value for a timestamp that is in the (not so distant)
    # past. This serves as a lower bound for valid system timestamps during
    # startup. Systemd will reset the system timestamp if this date is +- 15
    # years from the system time.
    # See the systemd v250 release notes for further details:
    #   https://github.com/systemd/systemd/blob/60e930fc3e6eb8a36fbc184773119eb8d2f30364/NEWS#L258-L266
    (lib.mesonOption "time-epoch" releaseTimestamp)

    (lib.mesonOption "version-tag" version)
    (lib.mesonOption "mode" "release")
    (lib.mesonOption "tty-gid" "3") # tty in NixOS has gid 3
    (lib.mesonOption "pamconfdir" "${placeholder "out"}/etc/pam.d")
    (lib.mesonOption "shellprofiledir" "${placeholder "out"}/etc/profile.d")
    (lib.mesonOption "kmod-path" "${kmod}/bin/kmod")

    # /bin/sh is also the upstream default. Explicitly set this so that we're
    # independent of upstream changes to the default.
    (lib.mesonOption "debug-shell" "/bin/sh")

    # Attempts to check /usr/sbin and that fails in macOS sandbox because
    # permission is denied. If /usr/sbin is not a symlink, it defaults to true.
    # We set it to false since stdenv moves sbin/* to bin and creates a symlink,
    # that is, we do not have split bin.
    (lib.mesonOption "split-bin" "false")

    # D-Bus
    (lib.mesonOption "dbuspolicydir" "${placeholder "out"}/share/dbus-1/system.d")
    (lib.mesonOption "dbussessionservicedir" "${placeholder "out"}/share/dbus-1/services")
    (lib.mesonOption "dbussystemservicedir" "${placeholder "out"}/share/dbus-1/system-services")

    # pkgconfig
    (lib.mesonOption "pkgconfiglibdir" "${placeholder "dev"}/lib/pkgconfig")
    (lib.mesonOption "pkgconfigdatadir" "${placeholder "dev"}/share/pkgconfig")

    # Keyboard
    (lib.mesonOption "loadkeys-path" "${kbd'}/bin/loadkeys")
    (lib.mesonOption "setfont-path" "${kbd'}/bin/setfont")

    # SBAT
    (lib.mesonOption "sbat-distro" "nixos")
    (lib.mesonOption "sbat-distro-summary" "NixOS")
    (lib.mesonOption "sbat-distro-url" "https://nixos.org/")
    (lib.mesonOption "sbat-distro-pkgname" pname)
    (lib.mesonOption "sbat-distro-version" version)

    # Users
    (lib.mesonOption "system-uid-max" "999")
    (lib.mesonOption "system-gid-max" "999")

    # SysVinit
    (lib.mesonOption "sysvinit-path" "")
    (lib.mesonOption "sysvrcnd-path" "")

    # Login
    (lib.mesonOption "sulogin-path" "${util-linux.login}/bin/sulogin")
    (lib.mesonOption "nologin-path" "${util-linux.login}/bin/nologin")

    # Mount
    (lib.mesonOption "mount-path" "${lib.getOutput "mount" util-linux}/bin/mount")
    (lib.mesonOption "umount-path" "${lib.getOutput "mount" util-linux}/bin/umount")

    # SSH
    (lib.mesonOption "sshconfdir" "")
    (lib.mesonOption "sshdconfdir" "no")

    # RPM
    # This stops building/installing RPM specific tools.
    (lib.mesonOption "rpmmacrosdir" "no")

    # Features

    # Tests
    (lib.mesonBool "tests" withTests)
    (lib.mesonEnable "glib" withTests)
    (lib.mesonEnable "dbus" withTests)

    # Compression
    (lib.mesonEnable "bzip2" withCompression)
    (lib.mesonEnable "lz4" withCompression)
    (lib.mesonEnable "xz" withCompression)
    (lib.mesonEnable "zstd" withCompression)
    (lib.mesonEnable "zlib" withCompression)

    # NSS
    (lib.mesonEnable "nss-mymachines" (withNss && withMachined))
    (lib.mesonEnable "nss-resolve" withNss)
    (lib.mesonBool "nss-myhostname" withNss)
    (lib.mesonBool "nss-systemd" withNss)

    # Cryptsetup
    (lib.mesonEnable "libcryptsetup" withCryptsetup)
    (lib.mesonEnable "libcryptsetup-plugins" withCryptsetup)
    (lib.mesonEnable "p11kit" (withHomed || withCryptsetup))

    # FIDO2
    (lib.mesonEnable "libfido2" withFido2)
    (lib.mesonEnable "openssl" withOpenSSL)

    # Password Quality
    (lib.mesonEnable "pwquality" withPasswordQuality)
    (lib.mesonEnable "passwdqc" false)

    # Remote
    (lib.mesonEnable "remote" withRemote)
    (lib.mesonEnable "microhttpd" withRemote)

    (lib.mesonEnable "pam" withPam)
    (lib.mesonEnable "acl" withAcl)
    (lib.mesonEnable "audit" withAudit)
    (lib.mesonEnable "apparmor" withApparmor)
    (lib.mesonEnable "gcrypt" withGcrypt)
    (lib.mesonEnable "importd" withImportd)
    (lib.mesonEnable "homed" withHomed)
    (lib.mesonEnable "polkit" withPolkit)
    (lib.mesonEnable "elfutils" withCoredump)
    (lib.mesonEnable "libcurl" wantCurl)
    (lib.mesonEnable "libidn" false)
    (lib.mesonEnable "libidn2" withLibidn2)
    (lib.mesonEnable "libiptc" false)
    (lib.mesonEnable "repart" withRepart)
    (lib.mesonEnable "sysupdate" withSysupdate)
    (lib.mesonEnable "sysupdated" withSysupdate)
    (lib.mesonEnable "seccomp" withLibseccomp)
    (lib.mesonEnable "selinux" withSelinux)
    (lib.mesonEnable "tpm2" withTpm2Tss)
    (lib.mesonEnable "pcre2" withPCRE2)
    (lib.mesonEnable "bpf-framework" withLibBPF)
    (lib.mesonEnable "bootloader" withBootloader)
    (lib.mesonEnable "ukify" withUkify)
    (lib.mesonEnable "kmod" withKmod)
    (lib.mesonEnable "qrencode" withQrencode)
    (lib.mesonEnable "vmspawn" withVmspawn)
    (lib.mesonEnable "libarchive" withLibarchive)
    (lib.mesonEnable "xenctrl" false)
    (lib.mesonEnable "gnutls" false)
    (lib.mesonEnable "xkbcommon" false)
    (lib.mesonEnable "man" true)
    # (lib.mesonEnable "nspawn" withNspawn) # nspawn build can be turned off on systemd 258, on 257.x it will just not be installed in systemdLibs but the build is unconditional

    (lib.mesonBool "analyze" withAnalyze)
    (lib.mesonBool "logind" withLogind)
    (lib.mesonBool "localed" withLocaled)
    (lib.mesonBool "hostnamed" withHostnamed)
    (lib.mesonBool "machined" withMachined)
    (lib.mesonBool "networkd" withNetworkd)
    (lib.mesonBool "oomd" withOomd)
    (lib.mesonBool "portabled" withPortabled)
    (lib.mesonBool "hwdb" withHwdb)
    (lib.mesonBool "timedated" withTimedated)
    (lib.mesonBool "timesyncd" withTimesyncd)
    (lib.mesonBool "userdb" withUserDb)
    (lib.mesonBool "coredump" withCoredump)
    (lib.mesonBool "firstboot" withFirstboot)
    (lib.mesonBool "resolve" withResolved)
    (lib.mesonBool "sysusers" withSysusers)
    (lib.mesonBool "efi" withEfi)
    (lib.mesonBool "utmp" withUtmp)
    (lib.mesonBool "log-trace" withLogTrace)
    (lib.mesonBool "kernel-install" withKernelInstall)
    (lib.mesonBool "quotacheck" false)
    (lib.mesonBool "ldconfig" false)
    (lib.mesonBool "install-sysconfdir" false)
    (lib.mesonBool "create-log-dirs" false)
    (lib.mesonBool "smack" true)
    (lib.mesonBool "b_pie" true)

  ]
  ++ lib.optionals (withShellCompletions == false) [
    (lib.mesonOption "bashcompletiondir" "no")
    (lib.mesonOption "zshcompletiondir" "no")
  ]
  ++ lib.optionals stdenv.hostPlatform.isMusl [
    (lib.mesonBool "gshadow" false)
    (lib.mesonBool "idn" false)
  ];
  preConfigure =
    let
      # A list of all the runtime binaries referenced by the source code (plus
      # scripts and unit files) of systemd executables, tests and libraries.
      # As soon as a dependency is lo longer required we should remove it from
      # the list.
      # The `where` attribute for each of the replacement patterns must be
      # exhaustive. If another (unhandled) case is found in the source code the
      # build fails with an error message.
      binaryReplacements = [
        {
          search = "/sbin/mkswap";
          replacement = "${lib.getBin util-linux}/sbin/mkswap";
          where = [
            "man/systemd-makefs@.service.xml"
          ];
        }
        {
          search = "/sbin/swapon";
          replacement = "${lib.getOutput "swap" util-linux}/sbin/swapon";
          where = [
            "src/core/swap.c"
            "src/basic/unit-def.h"
          ];
        }
        {
          search = "/sbin/swapoff";
          replacement = "${lib.getOutput "swap" util-linux}/sbin/swapoff";
          where = [ "src/core/swap.c" ];
        }
        {
          search = "/bin/echo";
          replacement = "${coreutils}/bin/echo";
          where = [
            "man/systemd-analyze.xml"
            "man/systemd.service.xml"
            "man/systemd-run.xml"
            "src/analyze/test-verify.c"
            "src/test/test-env-file.c"
            "src/test/test-fileio.c"
            "src/test/test-load-fragment.c"
          ];
        }
        {
          search = "/bin/cat";
          replacement = "${coreutils}/bin/cat";
          where = [
            "test/test-execute/exec-noexecpaths-simple.service"
            "src/journal/cat.c"
          ];
        }
        {
          search = "/usr/lib/systemd/systemd-fsck";
          replacement = "$out/lib/systemd/systemd-fsck";
          where = [ "man/systemd-fsck@.service.xml" ];
        }
      ]
      ++ lib.optionals withNspawn [
        {
          # we only need to patch getent when nspawn will actually be built/installed
          # as of systemd 257.x, nspawn will not be installed on systemdLibs, so we don't need to patch it
          # patching getent unconditionally here introduces infinite recursion on musl
          search = "/usr/bin/getent";
          replacement = "${getent}/bin/getent";
          where = [ "src/nspawn/nspawn-setuid.c" ];
        }
      ]
      ++ lib.optionals withImportd [
        {
          search = "\"gpg\"";
          replacement = "\\\"${gnupg}/bin/gpg\\\"";
          where = [ "src/import/pull-common.c" ];
        }
        {
          search = "\"tar\"";
          replacement = "\\\"${gnutar}/bin/tar\\\"";
          where = [
            "src/import/export-tar.c"
            "src/import/import-common.c"
            "src/import/import-tar.c"
          ];
          ignore = [
            # occurrences here refer to the tar sub command
            "src/sysupdate/sysupdate-resource.c"
            "src/sysupdate/sysupdate-transfer.c"
            "src/import/pull.c"
            "src/import/export.c"
            "src/import/import.c"
            "src/import/importd.c"
            # runs `tar` but also also creates a temporary directory with the string
            "src/import/pull-tar.c"
            # tar referenced as file suffix
            "src/shared/import-util.c"
          ];
        }
      ]
      ++ lib.optionals withKmod [
        {
          search = "/sbin/modprobe";
          replacement = "${lib.getBin kmod}/sbin/modprobe";
          where = [ "units/modprobe@.service" ];
        }
      ];

      # { replacement, search, where, ignore } -> List[str]
      mkSubstitute =
        {
          replacement,
          search,
          where,
          ignore ? [ ],
        }:
        map (path: "substituteInPlace ${path} --replace '${search}' \"${replacement}\"") where;
      mkEnsureSubstituted =
        {
          replacement,
          search,
          where,
          ignore ? [ ],
        }:
        let
          ignore' = lib.concatStringsSep "|" (
            ignore
            ++ [
              "^test"
              "NEWS"
            ]
          );
        in
        ''
          set +e
          search=$(grep '${search}' -r | grep -v "${replacement}" | grep -Ev "${ignore'}")
          set -e
          if [[ -n "$search" ]]; then
            echo "Not all references to '${search}' have been replaced. Found the following matches:"
            echo "$search"
            exit 1
          fi
        '';
    in
    ''
      mesonFlagsArray+=(-Dntp-servers="0.nixos.pool.ntp.org 1.nixos.pool.ntp.org 2.nixos.pool.ntp.org 3.nixos.pool.ntp.org")
      export LC_ALL="en_US.UTF-8";

      ${lib.concatStringsSep "\n" (lib.flatten (map mkSubstitute binaryReplacements))}
      ${lib.concatMapStringsSep "\n" mkEnsureSubstituted binaryReplacements}

      substituteInPlace src/libsystemd/sd-journal/catalog.c \
        --replace /usr/lib/systemd/catalog/ $out/lib/systemd/catalog/

      substituteInPlace src/import/pull-tar.c \
        --replace 'wait_for_terminate_and_check("tar"' 'wait_for_terminate_and_check("${gnutar}/bin/tar"'
    '';

  # These defines are overridden by CFLAGS and would trigger annoying
  # warning messages
  postConfigure = ''
    substituteInPlace config.h \
      --replace "POLKIT_AGENT_BINARY_PATH" "_POLKIT_AGENT_BINARY_PATH" \
      --replace "SYSTEMD_BINARY_PATH" "_SYSTEMD_BINARY_PATH" \
      --replace "SYSTEMD_CGROUP_AGENTS_PATH" "_SYSTEMD_CGROUP_AGENT_PATH"
  '';

  env.NIX_CFLAGS_COMPILE = toString (
    [
      # Can't say ${polkit.bin}/bin/pkttyagent here because that would
      # lead to a cyclic dependency.
      "-UPOLKIT_AGENT_BINARY_PATH"
      "-DPOLKIT_AGENT_BINARY_PATH=\"/run/current-system/sw/bin/pkttyagent\""

      # Set the release_agent on /sys/fs/cgroup/systemd to the
      # currently running systemd (/run/current-system/systemd) so
      # that we don't use an obsolete/garbage-collected release agent.
      "-USYSTEMD_CGROUP_AGENTS_PATH"
      "-DSYSTEMD_CGROUP_AGENTS_PATH=\"/run/current-system/systemd/lib/systemd/systemd-cgroups-agent\""

      "-USYSTEMD_BINARY_PATH"
      "-DSYSTEMD_BINARY_PATH=\"/run/current-system/systemd/lib/systemd/systemd\""

    ]
    ++ lib.optionals stdenv.hostPlatform.isMusl [
      "-D__UAPI_DEF_ETHHDR=0"
    ]
  );

  doCheck = true;

  # trigger the test -n "$DESTDIR" || mutate in upstreams build system
  preInstall = ''
    export DESTDIR=/
  '';

  mesonInstallTags = lib.optionals buildLibsOnly [
    "devel"
    "libudev"
    "libsystemd"
  ];

  postInstall =
    lib.optionalString (!buildLibsOnly) ''
      mkdir -p $out/example/systemd
      mv $out/lib/{binfmt.d,sysctl.d,tmpfiles.d} $out/example
      mv $out/lib/systemd/{system,user} $out/example/systemd

      rm -rf $out/etc/systemd/system

      # Fix reference to /bin/false in the D-Bus services.
      for i in $out/share/dbus-1/system-services/*.service; do
        substituteInPlace $i --replace /bin/false ${coreutils}/bin/false
      done

      # For compatibility with dependents that use sbin instead of bin.
      ln -s bin "$out/sbin"

      rm -rf $out/etc/rpm
    ''
    + lib.optionalString (!withKernelInstall) ''
      # "kernel-install" shouldn't be used on NixOS.
      find $out -name "*kernel-install*" -exec rm {} \;
    ''
    + lib.optionalString (!withDocumentation) ''
      rm -rf $out/share/doc
    ''
    + lib.optionalString (withKmod && !buildLibsOnly) ''
      mv $out/lib/modules-load.d $out/example
    ''
    + lib.optionalString withSysusers ''
      mv $out/lib/sysusers.d $out/example
    '';

  doInstallCheck = true;

  # check udev rules exposed by systemd
  # can't use `udevCheckHook` here as that would introduce infinite recursion
  installCheckPhase = ''
    runHook preInstallCheck

    ${lib.optionalString (
      !buildLibsOnly
    ) "$out/bin/udevadm verify --resolve-names=never --no-style $out/lib/udev/rules.d"}

    runHook postInstallCheck
  '';

  # Avoid *.EFI binary stripping.
  # At least on aarch64-linux strip removes too much from PE32+ files:
  #   https://github.com/NixOS/nixpkgs/issues/169693
  # The hack is to move EFI file out of lib/ before doStrip run and return it
  # after doStrip run.
  preFixup = lib.optionalString withBootloader ''
    mv $out/lib/systemd/boot/efi $out/dont-strip-me
  '';

  # Wrap in the correct path for LUKS2 tokens.
  postFixup =
    lib.optionalString withCryptsetup ''
      for f in bin/systemd-cryptsetup bin/systemd-cryptenroll; do
        # This needs to be in LD_LIBRARY_PATH because rpath on a binary is not propagated to libraries using dlopen, in this case `libcryptsetup.so`
        wrapProgram $out/$f --prefix LD_LIBRARY_PATH : ${placeholder "out"}/lib/cryptsetup
      done
    ''
    + lib.optionalString withBootloader ''
      mv $out/dont-strip-me $out/lib/systemd/boot/efi
    ''
    + lib.optionalString withUkify ''
      # To cross compile a derivation that builds a UKI with ukify, we need to wrap
      # ukify with the correct binutils. When wrapping, no splicing happens so we
      # have to explicitly pull binutils from targetPackages.
      wrapProgram $out/bin/ukify --prefix PATH : ${
        lib.makeBinPath [ targetPackages.stdenv.cc.bintools ]
      }:${placeholder "out"}/lib/systemd
    '';

  disallowedReferences =
    lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform)
      # 'or p' is for manually specified buildPackages as they dont have __spliced
      (
        builtins.filter (p: p != null) (
          builtins.map (p: p.__spliced.buildHost or p) finalAttrs.nativeBuildInputs
        )
      );

  disallowedRequisites = lib.optionals (!withUkify) [
    bash
    bashNonInteractive
  ];

  passthru = {
    # The `interfaceVersion` attribute below points out the incompatibilities
    # between systemd versions. When the new systemd build is
    # backwards-compatible with the previous one, then they can be switched at
    # runtime (the reboot being optional in this case); otherwise, a reboot is
    # needed - and therefore `interfaceVersion` should be incremented.
    interfaceVersion = 2;

    inherit
      withBootloader
      withCryptsetup
      withEfi
      withFido2
      withHostnamed
      withImportd
      withKmod
      withLocaled
      withMachined
      withNetworkd
      withPortabled
      withSysupdate
      withTimedated
      withTpm2Tss
      withUtmp
      util-linux
      kmod
      ;

    kbd = kbd';

    # Many TPM2-related units are only installed if this trio of features are
    # enabled. See https://github.com/systemd/systemd/blob/876ee10e0eb4bbb0920bdab7817a9f06cc34910f/units/meson.build#L521
    withTpm2Units = withTpm2Tss && withBootloader && withOpenSSL;

    tests =
      let
        # Some entries in the `nixosTests.systemd-*` set of attributes are collections of tests,
        # not individual tests themselves. Let's gather them into one set.
        gatherNixosTestsFromCollection =
          prefix: collection:
          lib.mapAttrs' (name: value: {
            name = "${prefix}-${name}";
            inherit value;
          }) collection;

        # Here's all the nixosTests that are collections of tests, rather than individual tests.
        collectedNixosTests = lib.mergeAttrsList (
          lib.mapAttrsToList gatherNixosTestsFromCollection {
            inherit (nixosTests)
              systemd-binfmt
              systemd-boot
              systemd-initrd-networkd
              systemd-repart
              installer-systemd-stage-1
              ;
          }
        );

        # ... and here's all the individual tests.
        individualNixosTests = {
          inherit (nixosTests)
            fsck-systemd-stage-1
            hibernate-systemd-stage-1
            switchTest
            systemd
            systemd-analyze
            systemd-bpf
            systemd-confinement
            systemd-coredump
            systemd-cryptenroll
            systemd-credentials-tpm2
            systemd-escaping
            systemd-initrd-btrfs-raid
            systemd-initrd-luks-fido2
            systemd-initrd-luks-keyfile
            systemd-initrd-luks-empty-passphrase
            systemd-initrd-luks-password
            systemd-initrd-luks-tpm2
            systemd-initrd-luks-unl0kr
            systemd-initrd-modprobe
            systemd-initrd-shutdown
            systemd-initrd-simple
            systemd-initrd-swraid
            systemd-initrd-vconsole
            systemd-initrd-networkd-ssh
            systemd-initrd-networkd-openvpn
            systemd-initrd-vlan
            systemd-journal
            systemd-journal-gateway
            systemd-journal-upload
            systemd-lock-handler
            systemd-machinectl
            systemd-networkd
            systemd-networkd-bridge
            systemd-networkd-dhcpserver
            systemd-networkd-dhcpserver-static-leases
            systemd-networkd-ipv6-prefix-delegation
            systemd-networkd-vrf
            systemd-no-tainted
            systemd-nspawn
            systemd-nspawn-configfile
            systemd-oomd
            systemd-portabled
            systemd-resolved
            systemd-shutdown
            systemd-sysupdate
            systemd-sysusers-mutable
            systemd-sysusers-immutable
            systemd-sysusers-password-option-override-ordering
            systemd-timesyncd
            systemd-timesyncd-nscd-dnssec
            systemd-user-linger
            systemd-user-tmpfiles-rules
            systemd-misc
            systemd-userdbd
            systemd-homed
            ;
        };

        # Finally, make an attrset we're fairly sure is just tests.
        relevantNixosTests = lib.mapAttrs (
          name: value:
          assert lib.assertMsg (lib.isDerivation value) "${name} is not a derivation";
          value
        ) (individualNixosTests // collectedNixosTests);
      in
      relevantNixosTests
      // {
        cross =
          let
            systemString = if stdenv.buildPlatform.isAarch64 then "gnu64" else "aarch64-multiplatform";
          in
          pkgsCross.${systemString}.systemd;

        pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      };
  };

  meta = {
    homepage = "https://www.freedesktop.org/wiki/Software/systemd/";
    description = "System and service manager for Linux";
    longDescription = ''
      systemd is a suite of basic building blocks for a Linux system. It
      provides a system and service manager that runs as PID 1 and starts the
      rest of the system. systemd provides aggressive parallelization
      capabilities, uses socket and D-Bus activation for starting services,
      offers on-demand starting of daemons, keeps track of processes using Linux
      control groups, maintains mount and automount points, and implements an
      elaborate transactional dependency-based service control logic. systemd
      supports SysV and LSB init scripts and works as a replacement for
      sysvinit. Other parts include a logging daemon, utilities to control basic
      system configuration like the hostname, date, locale, maintain a list of
      logged-in users and running containers and virtual machines, system
      accounts, runtime directories and settings, and daemons to manage simple
      network configuration, network time synchronization, log forwarding, and
      name resolution.
    '';
    license = with lib.licenses; [
      # Taken from https://raw.githubusercontent.com/systemd/systemd-stable/${finalAttrs.src.rev}/LICENSES/README.md
      bsd2
      bsd3
      cc0
      lgpl21Plus
      lgpl2Plus
      mit
      mit0
      ofl
      publicDomain
    ];
    teams = [ lib.teams.systemd ];
    pkgConfigModules = [
      "libsystemd"
      "libudev"
      "systemd"
      "udev"
    ];
    # See src/basic/missing_syscall_def.h
    platforms =
      with lib.platforms;
      lib.intersectLists linux (aarch ++ x86 ++ loongarch64 ++ m68k ++ mips ++ power ++ riscv ++ s390);
    priority = 10;
    badPlatforms = [
      # https://github.com/systemd/systemd/issues/20600#issuecomment-912338965
      lib.systems.inspect.platformPatterns.isStatic
    ];
  };
})
