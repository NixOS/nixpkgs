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

  # glib is only used during tests (test-bus-gvariant, test-bus-marshal)
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
, libfido2
, p11-kit

  # the (optional) BPF feature requires bpftool, libbpf, clang and llvm-strip to be available during build time.
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
, withOomd ? true
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
  # tests assume too much system access for them to be feasible for us right now
, withTests ? false

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
  wantGcrypt = withResolved || withImportd;
  version = "251.4";

  # Bump this variable on every (major) version change. See below (in the meson options list) for why.
  # command:
  #  $ curl -s https://api.github.com/repos/systemd/systemd/releases/latest | \
  #     jq '.created_at|strptime("%Y-%m-%dT%H:%M:%SZ")|mktime'
  releaseTimestamp = "1653143108";
in
stdenv.mkDerivation {
  inherit pname version;

  # We use systemd/systemd-stable for src, and ship NixOS-specific patches inside nixpkgs directly
  # This has proven to be less error-prone than the previous systemd fork.
  src = fetchFromGitHub {
    owner = "systemd";
    repo = "systemd-stable";
    rev = "v${version}";
    sha256 = "sha256-lfG6flT1k8LZBAdDK+cF9RjmJMkHMJquMjQK3MINFd8=";
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
    ./0004-Look-for-fsck-in-the-right-place.patch
    ./0005-Add-some-NixOS-specific-unit-directories.patch
    ./0006-Get-rid-of-a-useless-message-in-user-sessions.patch
    ./0007-hostnamed-localed-timedated-disable-methods-that-cha.patch
    ./0008-Fix-hwdb-paths.patch
    ./0009-Change-usr-share-zoneinfo-to-etc-zoneinfo.patch
    ./0010-localectl-use-etc-X11-xkb-for-list-x11.patch
    ./0011-build-don-t-create-statedir-and-don-t-touch-prefixdi.patch
    ./0012-add-rootprefix-to-lookup-dir-paths.patch
    ./0013-systemd-shutdown-execute-scripts-in-etc-systemd-syst.patch
    ./0014-systemd-sleep-execute-scripts-in-etc-systemd-system-.patch
    ./0015-path-util.h-add-placeholder-for-DEFAULT_PATH_NORMAL.patch
    ./0016-pkg-config-derive-prefix-from-prefix.patch
    ./0017-inherit-systemd-environment-when-calling-generators.patch
  ] ++ lib.optional stdenv.hostPlatform.isMusl (
    let
      oe-core = fetchzip {
        url = "https://git.openembedded.org/openembedded-core/snapshot/openembedded-core-86a33f98a7c0d6f2c2b51d02ba9e01b63062cf98.tar.bz2";
        sha256 = "081j01sw21hl405l7g9z4bavvq0q0k4g80365677m0ykhiqlx3am";
      };
      musl-patches = oe-core + "/meta/recipes-core/systemd/systemd";
    in
    [
      (musl-patches + "/0003-missing_type.h-add-comparison_fn_t.patch")
      (musl-patches + "/0004-add-fallback-parse_printf_format-implementation.patch")
      (musl-patches + "/0005-src-basic-missing.h-check-for-missing-strndupa.patch")
      (musl-patches + "/0007-don-t-fail-if-GLOB_BRACE-and-GLOB_ALTDIRFUNC-is-not-.patch")
      (musl-patches + "/0008-add-missing-FTW_-macros-for-musl.patch")
      (musl-patches + "/0010-Use-uintmax_t-for-handling-rlim_t.patch")
      (musl-patches + "/0011-test-sizeof.c-Disable-tests-for-missing-typedefs-in-.patch")
      (musl-patches + "/0012-don-t-pass-AT_SYMLINK_NOFOLLOW-flag-to-faccessat.patch")
      (musl-patches + "/0013-Define-glibc-compatible-basename-for-non-glibc-syste.patch")
      (musl-patches + "/0014-Do-not-disable-buffering-when-writing-to-oom_score_a.patch")
      (musl-patches + "/0015-distinguish-XSI-compliant-strerror_r-from-GNU-specif.patch")
      (musl-patches + "/0018-avoid-redefinition-of-prctl_mm_map-structure.patch")
      (musl-patches + "/0022-do-not-disable-buffer-in-writing-files.patch")
      (musl-patches + "/0025-Handle-__cpu_mask-usage.patch")
      (musl-patches + "/0026-Handle-missing-gshadow.patch")
      (musl-patches + "/0028-missing_syscall.h-Define-MIPS-ABI-defines-for-musl.patch")
      (musl-patches + "/0001-pass-correct-parameters-to-getdents64.patch")
      (musl-patches + "/0002-Add-sys-stat.h-for-S_IFDIR.patch")
      (musl-patches + "/0001-Adjust-for-musl-headers.patch")
    ]
  );

  postPatch = ''
    substituteInPlace src/basic/path-util.h --replace "@defaultPathNormal@" "${placeholder "out"}/bin/"
    substituteInPlace src/boot/efi/meson.build \
      --replace \
      "run_command(cc.cmd_array(), '-print-prog-name=objcopy', check: true).stdout().strip()" \
      "'${stdenv.cc.bintools.targetPrefix}objcopy'"
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
    patchShebangs tools test src/!(rpm)
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
      kmod
      libcap
      libidn2
      libuuid
      linuxHeaders
      pam
    ]

    ++ lib.optional wantGcrypt libgcrypt
    ++ lib.optional withTests glib
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
    # We bump this variable on every (major) version change to ensure
    # that we have known-good value for a timestamp that is in the (not so distant) past.
    # This serves as a lower bound for valid system timestamps during startup. Systemd will
    # reset the system timestamp if this date is +- 15 years from the system time.
    # See the systemd v250 release notes for further details:
    # https://github.com/systemd/systemd/blob/60e930fc3e6eb8a36fbc184773119eb8d2f30364/NEWS#L258-L266
    "-Dtime-epoch=${releaseTimestamp}"

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
    "-Dglib=${lib.boolToString withTests}"
    # while we do not run tests we should also not build them. Removes about 600 targets
    "-Dtests=false"
    "-Danalyze=${lib.boolToString withAnalyze}"
    "-Dgcrypt=${lib.boolToString wantGcrypt}"
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
    "-Dsbat-distro=nixos"
    "-Dsbat-distro-summary=NixOS"
    "-Dsbat-distro-url=https://nixos.org/"
    "-Dsbat-distro-pkgname=${pname}"
    "-Dsbat-distro-version=${version}"
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
  preConfigure =
    let
      # A list of all the runtime binaries that the systemd exectuables, tests and libraries are referencing in their source code, scripts and unit files.
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
        { search = "/sbin/swapon"; replacement = "${lib.getBin util-linux}/sbin/swapon"; where = [ "src/core/swap.c" "src/basic/unit-def.h" ]; }
        { search = "/sbin/swapoff"; replacement = "${lib.getBin util-linux}/sbin/swapoff"; where = [ "src/core/swap.c" ]; }
        {
          search = "/bin/echo";
          replacement = "${coreutils}/bin/echo";
          where = [
            "man/systemd-analyze.xml"
            "man/systemd.service.xml"
            "src/analyze/test-verify.c"
            "src/test/test-env-file.c"
            "src/test/test-fileio.c"
            "src/test/test-load-fragment.c"
          ];
        }
        {
          search = "/bin/cat";
          replacement = "${coreutils}/bin/cat";
          where = [ "test/create-busybox-container" "test/test-execute/exec-noexecpaths-simple.service" "src/journal/cat.c" ];
        }
        { search = "/sbin/modprobe"; replacement = "${lib.getBin kmod}/sbin/modprobe"; where = [ "units/modprobe@.service" ]; }
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
            # occurences here refer to the tar sub command
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
      ];

      # { replacement, search, where } -> List[str]
      mkSubstitute = { replacement, search, where, ignore ? [] }:
        map (path: "substituteInPlace ${path} --replace '${search}' \"${replacement}\"") where;
      mkEnsureSubstituted = { replacement, search, where, ignore ? [] }:
      let
        ignore' = lib.concatStringsSep "|" (ignore ++ ["^test" "NEWS"]);
      in ''
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

  NIX_CFLAGS_COMPILE = toString ([
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

  # Avoid *.EFI binary stripping. At least on aarch64-linux strip
  # removes too much from PE32+ files:
  #   https://github.com/NixOS/nixpkgs/issues/169693
  # The hack is to move EFI file out of lib/ before doStrip
  # run and return it after doStrip run.
  preFixup = lib.optionalString withEfi ''
    mv $out/lib/systemd/boot/efi $out/dont-strip-me
  '';
  postFixup = lib.optionalString withEfi ''
    mv $out/dont-strip-me $out/lib/systemd/boot/efi
  '';

  passthru = {
    # The interface version prevents NixOS from switching to an
    # incompatible systemd at runtime.  (Switching across reboots is
    # fine, of course.)  It should be increased whenever systemd changes
    # in a backwards-incompatible way.  If the interface version of two
    # systemd builds is the same, then we can switch between them at
    # runtime; otherwise we can't and we need to reboot.
    interfaceVersion = 2;

    inherit withCryptsetup withHostnamed withImportd withLocaled withMachined withTimedated util-linux kmod kbd;

    tests = {
      inherit (nixosTests) switchTest;
    };
  };

  meta = with lib; {
    homepage = "https://www.freedesktop.org/wiki/Software/systemd/";
    description = "A system and service manager for Linux";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    # https://github.com/systemd/systemd/issues/20600#issuecomment-912338965
    broken = stdenv.hostPlatform.isStatic;
    priority = 10;
    maintainers = with maintainers; [ flokli kloenk mic92 ];
  };
}
