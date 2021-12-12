{ stdenv, lib, buildPackages, fetchurl, fetchFromGitLab
, enableStatic ? stdenv.hostPlatform.isStatic
, enableMinimal ? false
, enableAppletSymlinks ? true
# Allow forcing musl without switching stdenv itself, e.g. for our bootstrapping:
# nix build -f pkgs/top-level/release.nix stdenvBootstrapTools.x86_64-linux.dist
, useMusl ? stdenv.hostPlatform.libc == "musl", musl
, extraConfig ? ""
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
in

stdenv.mkDerivation rec {
  pname = "busybox";
  version = "1.34.1";

  # Note to whoever is updating busybox: please verify that:
  # nix-build pkgs/stdenv/linux/make-bootstrap-tools.nix -A test
  # still builds after the update.
  src = fetchurl {
    url = "https://busybox.net/downloads/${pname}-${version}.tar.bz2";
    sha256 = "0jfm9fik7nv4w21zqdg830pddgkdjmplmna9yjn9ck1lwn4vsps1";
  };

  hardeningDisable = [ "format" "pie" ]
    ++ lib.optionals enableStatic [ "fortify" ];

  patches = [
    ./busybox-in-store.patch
  ] ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) ./clang-cross.patch;

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

  buildInputs = lib.optionals (enableStatic && !useMusl && stdenv.cc.libc ? static) [ stdenv.cc.libc stdenv.cc.libc.static ];

  enableParallelBuilding = true;

  enableParallelChecking = false;
  doCheck = true;
  preCheck = ''
    export SKIP_KNOWN_BUGS=1
    export SKIP_INTERNET_TESTS=1

    # tests rely on external tools we'd rather not depend on
    rm testsuite/unzip.tests \
      testsuite/hostname/hostname-works\
      testsuite/hostname/hostname-s-works

    # trips up on SIGPIPE issues from https://github.com/NixOS/nix/issues/2803
    # resulting in a never-terminating `yes`
    rm testsuite/md5sum.tests testsuite/sha*sum.tests

    # build environment won't have /usr/bin and won't be able
    # to create suid files
    sed -i -e '/cpio -p with absolute paths/iSKIP=1;' \
      -e '/cpio restores suid/iSKIP=1;' \
      testsuite/cpio.tests

    # won't work when our coreutils is also a multi-call-binary
    sed -i '/start-stop-daemon with both -x and -a/iSKIP=1;' \
      testsuite/start-stop-daemon.tests

    # build environment won't have `ls` in the "default path" but
    # should have `sh`
    sed -i 's/\bls\b/sh/g' testsuite/which/which-uses-default-path

    # help tests find tools in non-standard locations
    substituteInPlace testsuite/date/date-works-1 \
      --replace '/bin/date' "$(type -P date)"
    substituteInPlace testsuite/pwd/pwd-prints-working-directory \
      --replace '`which pwd`' "$(type -P pwd)"
  '';

  meta = with lib; {
    description = "Tiny versions of common UNIX utilities in a single small executable";
    homepage = "https://busybox.net/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ TethysSvensson qyliss ];
    platforms = platforms.linux;
    priority = 10;
  };
}
