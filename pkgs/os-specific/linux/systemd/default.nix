# NOTE: Make sure to (re-)format this file on changes with `nixpkgs-fmt`!

{ stdenv
, lib
, nixosTests
, pkgsCross
, fetchFromGitHub
, fetchzip
, buildPackages
, makeBinaryWrapper
, ninja
, meson
, m4
, pkg-config
, coreutils
, gperf
, getent
, glibcLocales

  # glib is only used during tests (test-bus-gvariant, test-bus-marshal)
, glib
, gettext
, python3Packages

  # Mandatory dependencies
, libcap
, util-linux
, kbd
, kmod
, libxcrypt

  # Optional dependencies
, pam
, cryptsetup
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
, elfutils
, linuxHeaders ? stdenv.cc.libc.linuxHeaders
, gnutls
, iptables
, withSelinux ? false
, libselinux
, withLibseccomp ? lib.meta.availableOn stdenv.hostPlatform libseccomp
, libseccomp
, withKexectools ? lib.meta.availableOn stdenv.hostPlatform kexec-tools
, kexec-tools
, bashInteractive
, bash
, libmicrohttpd
, libfido2
, p11-kit
, libpwquality
, qrencode

  # the (optional) BPF feature requires bpftool, libbpf, clang and llvm-strip to be available during build time.
  # Only libbpf should be a runtime dependency.
  # Note: llvmPackages is explicitly taken from buildPackages instead of relying
  # on splicing. Splicing will evaluate the adjacent (pkgsHostTarget) llvmPackages
  # which is sometimes problematic: llvmPackages.clang looks at targetPackages.stdenv.cc
  # which, in the unfortunate case of pkgsCross.ghcjs, `throw`s. If we explicitly
  # take buildPackages.llvmPackages, this is no problem because
  # `buildPackages.targetPackages.stdenv.cc == stdenv.cc` relative to us. Working
  # around this is important, because systemd is in the dependency closure of
  # GHC via emscripten and jdk.
, bpftools
, libbpf

  # Needed to produce a ukify that works for cross compiling UKIs.
, targetPackages

, withAcl ? true
, withAnalyze ? true
, withApparmor ? true
, withAudit ? true
  # compiles systemd-boot, assumes EFI is available.
, withBootloader ? withEfi
    && !stdenv.hostPlatform.isMusl
    # "Unknown 64-bit data model"
    && !stdenv.hostPlatform.isRiscV32
, withCompression ? true  # adds bzip2, lz4, xz and zstd
, withCoredump ? true
, withCryptsetup ? true
, withRepart ? true
, withDocumentation ? true
, withEfi ? stdenv.hostPlatform.isEfi
, withFido2 ? true
, withFirstboot ? false # conflicts with the NixOS /etc management
, withHomed ? !stdenv.hostPlatform.isMusl
, withHostnamed ? true
, withHwdb ? true
, withImportd ? !stdenv.hostPlatform.isMusl
, withIptables ? true
, withKmod ? true
, withLibBPF ? lib.versionAtLeast buildPackages.llvmPackages.clang.version "10.0"
    && (stdenv.hostPlatform.isAarch -> lib.versionAtLeast stdenv.hostPlatform.parsed.cpu.version "6") # assumes hard floats
    && !stdenv.hostPlatform.isMips64   # see https://github.com/NixOS/nixpkgs/pull/194149#issuecomment-1266642211
    # can't find gnu/stubs-32.h
    && (stdenv.hostPlatform.isPower64 -> stdenv.hostPlatform.isBigEndian)
    # https://reviews.llvm.org/D43106#1019077
    && (stdenv.hostPlatform.isRiscV32 -> stdenv.cc.isClang)
    # buildPackages.targetPackages.llvmPackages is the same as llvmPackages,
    # but we do it this way to avoid taking llvmPackages as an input, and
    # risking making it too easy to ignore the above comment about llvmPackages.
    && lib.meta.availableOn stdenv.hostPlatform buildPackages.targetPackages.llvmPackages.compiler-rt
, withLibidn2 ? true
, withLocaled ? true
, withLogind ? true
, withMachined ? true
, withNetworkd ? true
, withNss ? !stdenv.hostPlatform.isMusl
, withOomd ? true
, withPam ? true
, withPasswordQuality ? true
, withPCRE2 ? true
, withPolkit ? true
, withPortabled ? !stdenv.hostPlatform.isMusl
, withQrencode ? true
, withRemote ? !stdenv.hostPlatform.isMusl
, withResolved ? true
, withShellCompletions ? true
, withSysusers ? true
, withSysupdate ? true
, withTimedated ? true
, withTimesyncd ? true
, withTpm2Tss ? true
, withUkify ? false  # adds python to closure which is too much by default
, withUserDb ? true
, withUtmp ? !stdenv.hostPlatform.isMusl
, withVmspawn ? true
  # tests assume too much system access for them to be feasible for us right now
, withTests ? false
  # build only libudev and libsystemd
, buildLibsOnly ? false

  # name argument
, pname ? "systemd"

, libxslt
, docbook_xsl
, docbook_xml_dtd_42
, docbook_xml_dtd_45
, withLogTrace ? false
}:

assert withImportd -> withCompression;
assert withCoredump -> withCompression;
assert withHomed -> withCryptsetup;
assert withHomed -> withPam;
assert withUkify -> (withEfi && withBootloader);
assert withRepart -> withCryptsetup;
assert withBootloader -> withEfi;

let
  wantCurl = withRemote || withImportd;
  wantGcrypt = withResolved || withImportd;
  version = "255.2";

  # Bump this variable on every (major) version change. See below (in the meson options list) for why.
  # command:
  #  $ curl -s https://api.github.com/repos/systemd/systemd/releases/latest | \
  #     jq '.created_at|strptime("%Y-%m-%dT%H:%M:%SZ")|mktime'
  releaseTimestamp = "1701895110";
in
stdenv.mkDerivation (finalAttrs: {
  inherit pname version;

  # We use systemd/systemd-stable for src, and ship NixOS-specific patches inside nixpkgs directly
  # This has proven to be less error-prone than the previous systemd fork.
  src = fetchFromGitHub {
    owner = "systemd";
    repo = "systemd-stable";
    rev = "v${version}";
    hash = "sha256-8SfJY/pcH4yrDeJi0GfIUpetTbpMwyswvSu+RSfgqfY=";
  };

  # On major changes, or when otherwise required, you *must* reformat the patches,
  # `git am path/to/00*.patch` them into a systemd worktree, rebase to the more recent
  # systemd version, and export the patches again via
  # `git -c format.signoff=false format-patch v${version} --no-numbered --zero-commit --no-signature`.
  # Use `find . -name "*.patch" | sort` to get an up-to-date listing of all patches
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
  ] ++ lib.optional (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isGnu) [
    ./0018-timesyncd-disable-NSCD-when-DNSSEC-validation-is-dis.patch
  ] ++ lib.optional stdenv.hostPlatform.isMusl (
    let
      oe-core = fetchzip {
        url = "https://git.openembedded.org/openembedded-core/snapshot/openembedded-core-eb8a86fee9eeae787cc0a58ef2ed087fd48d93eb.tar.gz";
        sha256 = "tE2KpXLvOknIpEZFdOnNxvBmDvZrra3kvQp9tKxa51c=";
      };
      musl-patches = oe-core + "/meta/recipes-core/systemd/systemd";
    in
    [
      (musl-patches + "/0001-Adjust-for-musl-headers.patch")
      (musl-patches + "/0005-pass-correct-parameters-to-getdents64.patch")
      (musl-patches + "/0006-test-bus-error-strerror-is-assumed-to-be-GNU-specifi.patch")
      (musl-patches + "/0009-missing_type.h-add-comparison_fn_t.patch")
      (musl-patches + "/0010-add-fallback-parse_printf_format-implementation.patch")
      (musl-patches + "/0011-src-basic-missing.h-check-for-missing-strndupa.patch")
      (musl-patches + "/0012-don-t-fail-if-GLOB_BRACE-and-GLOB_ALTDIRFUNC-is-not-.patch")
      (musl-patches + "/0013-add-missing-FTW_-macros-for-musl.patch")
      (musl-patches + "/0014-Use-uintmax_t-for-handling-rlim_t.patch")
      (musl-patches + "/0016-don-t-pass-AT_SYMLINK_NOFOLLOW-flag-to-faccessat.patch")
      (musl-patches + "/0017-Define-glibc-compatible-basename-for-non-glibc-syste.patch")
      (musl-patches + "/0018-Do-not-disable-buffering-when-writing-to-oom_score_a.patch")
      (musl-patches + "/0019-distinguish-XSI-compliant-strerror_r-from-GNU-specif.patch")
      (musl-patches + "/0020-avoid-redefinition-of-prctl_mm_map-structure.patch")
      (musl-patches + "/0021-do-not-disable-buffer-in-writing-files.patch")
      (musl-patches + "/0022-Handle-__cpu_mask-usage.patch")
      (musl-patches + "/0023-Handle-missing-gshadow.patch")
      (musl-patches + "/0024-missing_syscall.h-Define-MIPS-ABI-defines-for-musl.patch")
      (musl-patches + "/0028-sd-event-Make-malloc_trim-conditional-on-glibc.patch")
      (musl-patches + "/0029-shared-Do-not-use-malloc_info-on-musl.patch")
    ]
  );

  postPatch = ''
    substituteInPlace src/basic/path-util.h --replace "@defaultPathNormal@" "${placeholder "out"}/bin/"
  '' + lib.optionalString withLibBPF ''
    substituteInPlace meson.build \
      --replace "find_program('clang'" "find_program('${stdenv.cc.targetPrefix}clang'"
  '' + lib.optionalString withUkify ''
    substituteInPlace src/ukify/ukify.py \
      --replace \
      "'readelf'" \
      "'${targetPackages.stdenv.cc.bintools.targetPrefix}readelf'" \
      --replace \
      "/usr/lib/systemd/boot/efi" \
      "$out/lib/systemd/boot/efi"
  '' + (
    let
      # The following patches references to dynamic libraries to ensure that
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
          # bpf compilation support. We use libbpf 1 now.
          { name = "libbpf.so.1"; pkg = opt withLibBPF libbpf; }
          { name = "libbpf.so.0"; pkg = null; }

          # We did never provide support for libxkbcommon
          { name = "libxkbcommon.so.0"; pkg = null; }

          # qrencode
          { name = "libqrencode.so.4"; pkg = opt withQrencode qrencode; }
          { name = "libqrencode.so.3"; pkg = null; }

          # Password quality
          # We currently do not package passwdqc, only libpwquality.
          { name = "libpwquality.so.1"; pkg = opt withPasswordQuality libpwquality; }
          { name = "libpasswdqc.so.1"; pkg = null; }

          # Only include cryptsetup if it is enabled. We might not be able to
          # provide it during "bootstrap" in e.g. the minimal systemd build as
          # cryptsetup has udev (aka systemd) in it's dependencies.
          { name = "libcryptsetup.so.12"; pkg = opt withCryptsetup cryptsetup; }

          # We are using libidn2 so we only provide that and ignore the others.
          # Systemd does this decision during configure time and uses ifdef's to
          # enable specific branches. We can safely ignore (nuke) the libidn "v1"
          # libraries.
          { name = "libidn2.so.0"; pkg = opt withLibidn2 libidn2; }
          { name = "libidn.so.12"; pkg = null; }
          { name = "libidn.so.11"; pkg = null; }

          # journalctl --grep requires libpcre so let's provide it
          { name = "libpcre2-8.so.0"; pkg = pcre2; }

          # Support for TPM2 in systemd-cryptsetup, systemd-repart and systemd-cryptenroll
          { name = "libtss2-esys.so.0"; pkg = opt withTpm2Tss tpm2-tss; }
          { name = "libtss2-rc.so.0"; pkg = opt withTpm2Tss tpm2-tss; }
          { name = "libtss2-mu.so.0"; pkg = opt withTpm2Tss tpm2-tss; }
          { name = "libtss2-tcti-"; pkg = opt withTpm2Tss tpm2-tss; }
          { name = "libfido2.so.1"; pkg = opt withFido2 libfido2; }

          # inspect-elf support
          { name = "libelf.so.1"; pkg = opt withCoredump elfutils; }
          { name = "libdw.so.1"; pkg = opt withCoredump elfutils; }

          # Support for PKCS#11 in systemd-cryptsetup, systemd-cryptenroll and systemd-homed
          { name = "libp11-kit.so.0"; pkg = opt (withHomed || withCryptsetup) p11-kit; }

          { name = "libip4tc.so.2"; pkg = opt withIptables iptables; }
        ];

      patchDlOpen = dl:
        let
          library = "${lib.makeLibraryPath [ dl.pkg ]}/${dl.name}";
        in
        if dl.pkg == null then ''
          # remove the dependency on the library by replacing it with an invalid path
          for file in $(grep -lr '"${dl.name}"' src); do
            echo "patching dlopen(\"${dl.name}\", …) in $file to an invalid store path ("${builtins.storeDir}/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-not-implemented/${dl.name}")…"
            substituteInPlace "$file" --replace '"${dl.name}"' '"${builtins.storeDir}/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-not-implemented/${dl.name}"'
          done
        '' else ''
          # ensure that the library we provide actually exists
          if ! [ -e ${library} ]; then
            # exceptional case, details:
            # https://github.com/systemd/systemd-stable/blob/v249-stable/src/shared/tpm2-util.c#L157
            if ! [[ "${library}" =~ .*libtss2-tcti-$ ]]; then
              echo 'The shared library `${library}` does not exist but was given as substitute for `${dl.name}`'
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
  # Finally, patch shebangs in scripts used at build time. This must not patch
  # scripts that will end up in the output, to avoid build platform references
  # when cross-compiling.
  + ''
    shopt -s extglob
    patchShebangs tools test src/!(rpm|kernel-install|ukify) src/kernel-install/test-kernel-install.sh
  '';

  outputs = [ "out" "dev" ] ++ (lib.optional (!buildLibsOnly) "man");

  nativeBuildInputs =
    [
      pkg-config
      makeBinaryWrapper
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
      bash
      (buildPackages.python3Packages.python.withPackages (ps: with ps; [ lxml jinja2 ] ++ lib.optional withEfi ps.pyelftools))
    ]
    ++ lib.optionals withLibBPF [
      bpftools
      buildPackages.llvmPackages.clang
      buildPackages.llvmPackages.libllvm
    ]
  ;

  buildInputs =
    [
      libxcrypt
      libcap
      libuuid
      linuxHeaders
      bashInteractive # for patch shebangs
    ]

    ++ lib.optionals wantGcrypt [ libgcrypt libgpg-error ]
    ++ lib.optional withTests glib
    ++ lib.optional withAcl acl
    ++ lib.optional withApparmor libapparmor
    ++ lib.optional withAudit audit
    ++ lib.optional wantCurl (lib.getDev curl)
    ++ lib.optionals withCompression [ zlib bzip2 lz4 xz zstd ]
    ++ lib.optional withCoredump elfutils
    ++ lib.optional withCryptsetup (lib.getDev cryptsetup.dev)
    ++ lib.optional withKexectools kexec-tools
    ++ lib.optional withKmod kmod
    ++ lib.optional withLibidn2 libidn2
    ++ lib.optional withLibseccomp libseccomp
    ++ lib.optional withIptables iptables
    ++ lib.optional withPam pam
    ++ lib.optional withPCRE2 pcre2
    ++ lib.optional withSelinux libselinux
    ++ lib.optionals withRemote [ libmicrohttpd gnutls ]
    ++ lib.optionals (withHomed || withCryptsetup) [ p11-kit ]
    ++ lib.optionals (withHomed || withCryptsetup) [ libfido2 ]
    ++ lib.optionals withLibBPF [ libbpf ]
    ++ lib.optional withTpm2Tss tpm2-tss
    ++ lib.optional withUkify (python3Packages.python.withPackages (ps: with ps; [ pefile ]))
    ++ lib.optionals withPasswordQuality [ libpwquality ]
    ++ lib.optionals withQrencode [ qrencode ]
  ;

  mesonBuildType = "release";

  mesonFlags = [
    # Options

    # We bump this variable on every (major) version change to ensure
    # that we have known-good value for a timestamp that is in the (not so distant) past.
    # This serves as a lower bound for valid system timestamps during startup. Systemd will
    # reset the system timestamp if this date is +- 15 years from the system time.
    # See the systemd v250 release notes for further details:
    # https://github.com/systemd/systemd/blob/60e930fc3e6eb8a36fbc184773119eb8d2f30364/NEWS#L258-L266
    (lib.mesonOption "time-epoch" releaseTimestamp)

    (lib.mesonOption "version-tag" version)
    (lib.mesonOption "mode" "release")
    (lib.mesonOption "tty-gid" "3") # tty in NixOS has gid 3
    (lib.mesonOption "debug-shell" "${bashInteractive}/bin/bash")
    (lib.mesonOption "pamconfdir" "${placeholder "out"}/etc/pam.d")
    # Use cgroupsv2. This is already the upstream default, but better be explicit.
    (lib.mesonOption "default-hierarchy" "unified")
    (lib.mesonOption "kmod-path" "${kmod}/bin/kmod")

    # D-Bus
    (lib.mesonOption "dbuspolicydir" "${placeholder "out"}/share/dbus-1/system.d")
    (lib.mesonOption "dbussessionservicedir" "${placeholder "out"}/share/dbus-1/services")
    (lib.mesonOption "dbussystemservicedir" "${placeholder "out"}/share/dbus-1/system-services")

    # pkgconfig
    (lib.mesonOption "pkgconfiglibdir" "${placeholder "dev"}/lib/pkgconfig")
    (lib.mesonOption "pkgconfigdatadir" "${placeholder "dev"}/share/pkgconfig")

    # Keyboard
    (lib.mesonOption "loadkeys-path" "${kbd}/bin/loadkeys")
    (lib.mesonOption "setfont-path" "${kbd}/bin/setfont")

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
    (lib.mesonEnable "nss-mymachines" withNss)
    (lib.mesonEnable "nss-resolve" withNss)
    (lib.mesonBool "nss-myhostname" withNss)
    (lib.mesonBool "nss-systemd" withNss)

    # Cryptsetup
    (lib.mesonEnable "libcryptsetup" withCryptsetup)
    (lib.mesonEnable "libcryptsetup-plugins" withCryptsetup)
    (lib.mesonEnable "p11kit" (withHomed || withCryptsetup))

    # FIDO2
    (lib.mesonEnable "libfido2" withFido2)
    (lib.mesonEnable "openssl" withFido2)

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
    (lib.mesonEnable "gcrypt" wantGcrypt)
    (lib.mesonEnable "importd" withImportd)
    (lib.mesonEnable "homed" withHomed)
    (lib.mesonEnable "polkit" withPolkit)
    (lib.mesonEnable "elfutils" withCoredump)
    (lib.mesonEnable "libcurl" wantCurl)
    (lib.mesonEnable "libidn" false)
    (lib.mesonEnable "libidn2" withLibidn2)
    (lib.mesonEnable "libiptc" withIptables)
    (lib.mesonEnable "repart" withRepart)
    (lib.mesonEnable "sysupdate" withSysupdate)
    (lib.mesonEnable "selinux" withSelinux)
    (lib.mesonEnable "tpm2" withTpm2Tss)
    (lib.mesonEnable "pcre2" withPCRE2)
    (lib.mesonEnable "bpf-framework" withLibBPF)
    (lib.mesonEnable "bootloader" withBootloader)
    (lib.mesonEnable "ukify" withUkify)
    (lib.mesonEnable "kmod" withKmod)
    (lib.mesonEnable "qrencode" withQrencode)
    (lib.mesonEnable "vmspawn" withVmspawn)
    (lib.mesonEnable "xenctrl" false)
    (lib.mesonEnable "gnutls" false)
    (lib.mesonEnable "xkbcommon" false)
    (lib.mesonEnable "man" true)

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
    (lib.mesonBool "quotacheck" false)
    (lib.mesonBool "ldconfig" false)
    (lib.mesonBool "install-sysconfdir" false)
    (lib.mesonBool "create-log-dirs" false)
    (lib.mesonBool "smack" true)
    (lib.mesonBool "b_pie" true)

  ] ++ lib.optionals (withShellCompletions == false) [
    (lib.mesonOption "bashcompletiondir" "no")
    (lib.mesonOption "zshcompletiondir" "no")
  ] ++ lib.optionals stdenv.hostPlatform.isMusl [
    (lib.mesonBool "gshadow" false)
    (lib.mesonBool "idn" false)
  ];
  preConfigure =
    let
      # A list of all the runtime binaries that the systemd executables, tests and libraries are referencing in their source code, scripts and unit files.
      # As soon as a dependency isn't required anymore we should remove it from the list. The `where` attribute for each of the replacement patterns must be exhaustive. If another (unhandled) case is found in the source code the build fails with an error message.
      binaryReplacements = [
        { search = "/usr/bin/getent"; replacement = "${getent}/bin/getent"; where = [ "src/nspawn/nspawn-setuid.c" ]; }

        {
          search = "/sbin/mkswap";
          replacement = "${lib.getBin util-linux}/sbin/mkswap";
          where = [
            "man/systemd-makefs@.service.xml"
          ];
        }
        { search = "/sbin/swapon"; replacement = "${lib.getOutput "swap" util-linux}/sbin/swapon"; where = [ "src/core/swap.c" "src/basic/unit-def.h" ]; }
        { search = "/sbin/swapoff"; replacement = "${lib.getOutput "swap" util-linux}/sbin/swapoff"; where = [ "src/core/swap.c" ]; }
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
          where = [ "test/test-execute/exec-noexecpaths-simple.service" "src/journal/cat.c" ];
        }
        {
          search = "/usr/lib/systemd/systemd-fsck";
          replacement = "$out/lib/systemd/systemd-fsck";
          where = [
            "man/systemd-fsck@.service.xml"
          ];
        }
      ] ++ lib.optionals withImportd [
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
          ];
        }
      ] ++ lib.optionals withKmod [
        { search = "/sbin/modprobe"; replacement = "${lib.getBin kmod}/sbin/modprobe"; where = [ "units/modprobe@.service" ]; }
      ];

      # { replacement, search, where } -> List[str]
      mkSubstitute = { replacement, search, where, ignore ? [ ] }:
        map (path: "substituteInPlace ${path} --replace '${search}' \"${replacement}\"") where;
      mkEnsureSubstituted = { replacement, search, where, ignore ? [ ] }:
        let
          ignore' = lib.concatStringsSep "|" (ignore ++ [ "^test" "NEWS" ]);
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

  env.NIX_CFLAGS_COMPILE = toString ([
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

  ] ++ lib.optionals stdenv.hostPlatform.isMusl [
    "-D__UAPI_DEF_ETHHDR=0"
  ]);

  doCheck = false; # fails a bunch of tests

  # trigger the test -n "$DESTDIR" || mutate in upstreams build system
  preInstall = ''
    export DESTDIR=/
  '';

  mesonInstallTags = lib.optionals buildLibsOnly [ "devel" "libudev" "libsystemd" ];

  postInstall = lib.optionalString (!buildLibsOnly) ''
    mkdir -p $out/example/systemd
    mv $out/lib/{binfmt.d,sysctl.d,tmpfiles.d} $out/example
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
  '' + lib.optionalString (withKmod && !buildLibsOnly) ''
    mv $out/lib/modules-load.d $out/example
  '' + lib.optionalString withSysusers ''
    mv $out/lib/sysusers.d $out/example
  '';

  # Avoid *.EFI binary stripping. At least on aarch64-linux strip
  # removes too much from PE32+ files:
  #   https://github.com/NixOS/nixpkgs/issues/169693
  # The hack is to move EFI file out of lib/ before doStrip
  # run and return it after doStrip run.
  preFixup = lib.optionalString withBootloader ''
    mv $out/lib/systemd/boot/efi $out/dont-strip-me
  '';

  # Wrap in the correct path for LUKS2 tokens.
  postFixup = lib.optionalString withCryptsetup ''
    for f in bin/systemd-cryptsetup bin/systemd-cryptenroll; do
      # This needs to be in LD_LIBRARY_PATH because rpath on a binary is not propagated to libraries using dlopen, in this case `libcryptsetup.so`
      wrapProgram $out/$f --prefix LD_LIBRARY_PATH : ${placeholder "out"}/lib/cryptsetup
    done
  '' + lib.optionalString withBootloader ''
    mv $out/dont-strip-me $out/lib/systemd/boot/efi
  '' + lib.optionalString withUkify ''
    # To cross compile a derivation that builds a UKI with ukify, we need to wrap
    # ukify with the correct binutils. When wrapping, no splicing happens so we
    # have to explicitly pull binutils from targetPackages.
    wrapProgram $out/bin/ukify --prefix PATH : ${lib.makeBinPath [ targetPackages.stdenv.cc.bintools ] }:${placeholder "out"}/lib/systemd
  '';

  disallowedReferences = lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform)
    # 'or p' is for manually specified buildPackages as they dont have __spliced
    (builtins.map (p: p.__spliced.buildHost or p) finalAttrs.nativeBuildInputs);

  passthru = {
    # The interface version prevents NixOS from switching to an
    # incompatible systemd at runtime.  (Switching across reboots is
    # fine, of course.)  It should be increased whenever systemd changes
    # in a backwards-incompatible way.  If the interface version of two
    # systemd builds is the same, then we can switch between them at
    # runtime; otherwise we can't and we need to reboot.
    interfaceVersion = 2;

    inherit withCryptsetup withHostnamed withImportd withKmod withLocaled withMachined withPortabled withTimedated withUtmp util-linux kmod kbd;

    tests = {
      inherit (nixosTests)
        switchTest
        systemd-journal
        systemd-journal-gateway
        systemd-journal-upload;
      cross = pkgsCross.${if stdenv.buildPlatform.isAarch64 then "gnu64" else "aarch64-multiplatform"}.systemd;
    };
  };

  meta = with lib; {
    homepage = "https://www.freedesktop.org/wiki/Software/systemd/";
    description = "A system and service manager for Linux";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    badPlatforms = [ lib.systems.inspect.platformPatterns.isStatic ];
    # https://github.com/systemd/systemd/issues/20600#issuecomment-912338965
    broken = stdenv.hostPlatform.isStatic;
    priority = 10;
    maintainers = with maintainers; [ flokli kloenk ];
  };
})
