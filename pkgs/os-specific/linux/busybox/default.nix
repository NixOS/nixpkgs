{
  stdenv,
  lib,
  buildPackages,
  fetchurl,
  fetchpatch,
  fetchFromGitLab,
  enableStatic ? stdenv.hostPlatform.isStatic,
  enableMinimal ? false,
  enableAppletSymlinks ? true,
  # Allow forcing musl without switching stdenv itself, e.g. for our bootstrapping:
  # nix build -f pkgs/top-level/release.nix stdenvBootstrapTools.x86_64-linux.dist
  useMusl ? stdenv.hostPlatform.libc == "musl",
  musl,
  extraConfig ? "",

  # For tests
  hostname,
  coreutils,
  zip,
  which,
  simple-http-server,
}:

assert stdenv.hostPlatform.libc == "musl" -> useMusl;

let
  configParser = ''
    function parseconfig {
        while read LINE; do
            NAME=`echo "$LINE" | cut -d \  -f 1`
            OPTION=`echo "$LINE" | cut -d \  -f 2`

            if ! [[ "$NAME" =~ ^CONFIG_ ]]; then continue; fi

            echo "parseconfig: removing $NAME"
            sed -i /$NAME'\(=\| \)'/d .config

            echo "parseconfig: setting $NAME=$OPTION"
            echo "$NAME=$OPTION" >> .config
        done
    }
  '';

  libcConfig = lib.optionalString useMusl ''
    CONFIG_FEATURE_UTMP n
    CONFIG_FEATURE_WTMP n
  '';

  # The debian version lags behind the upstream version and also contains
  # a debian-specific suffix. We only fetch the debian repository to get the
  # default.script
  debianVersion = "1.30.1-6";
  debianSource = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "installer-team";
    repo = "busybox";
    rev = "debian/1%${debianVersion}";
    sha256 = "sha256-6r0RXtmqGXtJbvLSD1Ma1xpqR8oXL2bBKaUE/cSENL8=";
  };
  debianDispatcherScript = "${debianSource}/debian/tree/udhcpc/etc/udhcpc/default.script";
  outDispatchPath = "$out/default.script";

  pname = "busybox";
  version = "1.36.1";
in

stdenv.mkDerivation (finalAttrs: {
  inherit pname version;

  # Note to whoever is updating busybox: please verify that:
  # nix-build pkgs/stdenv/linux/make-bootstrap-tools.nix -A test
  # still builds after the update.
  src = fetchurl {
    url = "https://busybox.net/downloads/${pname}-${version}.tar.bz2";
    sha256 = "sha256-uMwkyVdNgJ5yecO+NJeVxdXOtv3xnKcJ+AzeUOR94xQ=";
  };

  hardeningDisable = [
    "format"
  ]
  ++ lib.optionals enableStatic [ "fortify" ];

  patches = [
    ./busybox-in-store.patch
    (fetchurl {
      name = "CVE-2022-28391.patch";
      url = "https://git.alpinelinux.org/aports/plain/main/busybox/0001-libbb-sockaddr2str-ensure-only-printable-characters-.patch?id=ed92963eb55bbc8d938097b9ccb3e221a94653f4";
      sha256 = "sha256-yviw1GV+t9tbHbY7YNxEqPi7xEreiXVqbeRyf8c6Awo=";
    })
    (fetchurl {
      name = "CVE-2022-28391.patch";
      url = "https://git.alpinelinux.org/aports/plain/main/busybox/0002-nslookup-sanitize-all-printed-strings-with-printable.patch?id=ed92963eb55bbc8d938097b9ccb3e221a94653f4";
      sha256 = "sha256-vl1wPbsHtXY9naajjnTicQ7Uj3N+EQ8pRNnrdsiow+w=";
    })
    (fetchpatch {
      name = "CVE-2022-48174.patch"; # https://bugs.busybox.net/show_bug.cgi?id=15216
      url = "https://git.busybox.net/busybox/patch/?id=d417193cf37ca1005830d7e16f5fa7e1d8a44209";
      hash = "sha256-mpDEwYncpU6X6tmtj9xM2KCrB/v2ys5bYxmPPrhm6es=";
    })
    (fetchpatch {
      name = "CVE-2023-42366.patch"; # https://bugs.busybox.net/show_bug.cgi?id=15874
      # This patch is also used by Alpine, see https://git.alpinelinux.org/aports/tree/main/busybox/0037-awk.c-fix-CVE-2023-42366-bug-15874.patch
      url = "https://bugs.busybox.net/attachment.cgi?id=9697";
      hash = "sha256-2eYfLZLjStea9apKXogff6sCAdG9yHx0ZsgUBaGfQIA=";
    })
    (fetchpatch {
      name = "CVE-2023-42363.patch"; # https://bugs.busybox.net/show_bug.cgi?id=15865
      url = "https://git.launchpad.net/ubuntu/+source/busybox/plain/debian/patches/CVE-2023-42363.patch?id=c9d8a323b337d58e302717d41796aa0242963d5a";
      hash = "sha256-1W9Q8+yFkYQKzNTrvndie8QuaEbyAFL1ZASG2fPF+Z4=";
    })
    (fetchpatch {
      name = "CVE-2023-42364_CVE-2023-42365.patch"; # https://bugs.busybox.net/show_bug.cgi?id=15871 https://bugs.busybox.net/show_bug.cgi?id=15868
      url = "https://git.alpinelinux.org/aports/plain/main/busybox/CVE-2023-42364-CVE-2023-42365.patch?id=8a4bf5971168bf48201c05afda7bee0fbb188e13";
      hash = "sha256-nQPgT9eA1asCo38Z9X7LR9My0+Vz5YBPba3ARV3fWcc=";
    })
    (fetchurl {
      url = "https://git.alpinelinux.org/aports/plain/main/busybox/0001-tar-fix-TOCTOU-symlink-race-condition.patch?id=9e42dea5fba84a8afad1f1910b7d3884128a567e";
      hash = "sha256-GmXQhwB1/IPVjXXpGi5RjRvuGJgIMIb7lQKB63m306g=";
    })
  ]
  ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) ./clang-cross.patch;

  separateDebugInfo = true;

  postPatch = "patchShebangs .";

  configurePhase = ''
    export KCONFIG_NOTIMESTAMP=1
    make ${if enableMinimal then "allnoconfig" else "defconfig"}

    ${configParser}

    cat << EOF | parseconfig

    CONFIG_PREFIX "$out"
    CONFIG_INSTALL_NO_USR y

    CONFIG_LFS y

    # More features for modprobe.
    ${lib.optionalString (!enableMinimal) ''
      CONFIG_FEATURE_MODPROBE_BLACKLIST y
      CONFIG_FEATURE_MODUTILS_ALIAS y
      CONFIG_FEATURE_MODUTILS_SYMBOLS y
      CONFIG_MODPROBE_SMALL n
    ''}

    ${lib.optionalString enableStatic ''
      CONFIG_STATIC y
    ''}

    ${lib.optionalString (!enableAppletSymlinks) ''
      CONFIG_INSTALL_APPLET_DONT y
      CONFIG_INSTALL_APPLET_SYMLINKS n
    ''}

    # Use the external mount.cifs program.
    CONFIG_FEATURE_MOUNT_CIFS n
    CONFIG_FEATURE_MOUNT_HELPERS y

    # Set paths for console fonts.
    CONFIG_DEFAULT_SETFONT_DIR "/etc/kbd"

    # Bump from 4KB, much faster I/O
    CONFIG_FEATURE_COPYBUF_KB 64

    # Doesn't build with current kernel headers.
    # https://bugs.busybox.net/show_bug.cgi?id=15934
    CONFIG_TC n

    # Set the path for the udhcpc script
    CONFIG_UDHCPC_DEFAULT_SCRIPT "${outDispatchPath}"

    ${extraConfig}
    CONFIG_CROSS_COMPILER_PREFIX "${stdenv.cc.targetPrefix}"
    ${libcConfig}
    EOF

    make oldconfig

    runHook postConfigure
  '';

  postConfigure = lib.optionalString (useMusl && stdenv.hostPlatform.libc != "musl") ''
    makeFlagsArray+=("CC=${stdenv.cc.targetPrefix}cc -isystem ${musl.dev}/include -B${musl}/lib -L${musl}/lib")
  '';

  makeFlags = [ "SKIP_STRIP=y" ];

  postInstall = ''
    sed -e '
    1 a busybox() { '$out'/bin/busybox "$@"; }\
    logger() { '$out'/bin/logger "$@"; }\
    ' ${debianDispatcherScript} > ${outDispatchPath}
    chmod 555 ${outDispatchPath}
    HOST_PATH=$out/bin patchShebangs --host ${outDispatchPath}
  '';

  strictDeps = true;

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  buildInputs = lib.optionals (enableStatic && !useMusl && stdenv.cc.libc ? static) [
    stdenv.cc.libc
    stdenv.cc.libc.static
  ];

  enableParallelBuilding = true;

  doCheck = false; # Takes a while, requires extra dependencies
  passthru = {
    shellPath = "/bin/ash";

    tests.withCheck = finalAttrs.finalPackage.overrideAttrs (_: {
      doCheck = true;

      nativeCheckInputs = [
        hostname
        zip
        which
        simple-http-server
      ];

      preCheck = ''
        # Replace hard-coded dependencies on /bin
        sed -i 's|/bin/date|${lib.getExe' coreutils "date"}|' testsuite/date/date-works-1

        # wget tests rely on network access, use simple-http-server instead
        simple-http-server --index &
        sed -i 's|http://www.google.com|http://127.0.0.1:8000|' testsuite/wget/*

        skip-files() {
          for file in "$@"; do
            echo "echo SKIPPED $file; exit 0" > $file
          done
        }

        skip-testcase() {
          sed -i "s@testing \"$2\"@echo SKIPPED $2 || testing \"$2\"@" "$1"
        }

        # Skip known-broken tests
        export SKIP_KNOWN_BUGS=y

        # There are some semi-expected locale-related issues, disable tests that rely on it
        export CONFIG_UNICODE_USING_LOCALE=y

        # DISABLE SOME TESTS
        # TODO(balsoft): fix the tests instead of skipping

        pushd testsuite

        # Weird failures, may or may not be related to locales
        skip-files du/du-{h,k,l}-works

        # Relies on a default PATH (/bin/ls in particular)
        skip-files which/which-uses-default-path

        # Hangs indefinitely if run from sandbox
        skip-files md5sum.tests

        # Doesn't work with coreutils's "false"
        skip-testcase start-stop-daemon.tests "start-stop-daemon with both -x and -a"

        # Relies on /usr/bin
        skip-testcase cpio.tests "cpio -p with absolute paths"

        # Relies on suid/guid bits
        skip-testcase cpio.tests "cpio restores suid/sgid bits"

        popd
      '';
    });
  };

  meta = with lib; {
    description = "Tiny versions of common UNIX utilities in a single small executable";
    homepage = "https://busybox.net/";
    license = licenses.gpl2Only;
    mainProgram = "busybox";
    maintainers = with maintainers; [
      TethysSvensson
      qyliss
    ];
    platforms = platforms.linux;
    priority = 15; # below systemd (halt, init, poweroff, reboot) and coreutils
  };
})
