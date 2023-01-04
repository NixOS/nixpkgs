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
  version = "1.36.0";

  # Note to whoever is updating busybox: please verify that:
  # nix-build pkgs/stdenv/linux/make-bootstrap-tools.nix -A test
  # still builds after the update.
  src = fetchurl {
    url = "https://busybox.net/downloads/${pname}-${version}.tar.bz2";
    sha256 = "sha256-VCdQyK98smMOIBeAtPmfPczusG9QW0eexoJBweavYaU=";
  };

  hardeningDisable = [ "format" "pie" ]
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

  doCheck = false; # tries to access the net

  meta = with lib; {
    description = "Tiny versions of common UNIX utilities in a single small executable";
    homepage = "https://busybox.net/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ TethysSvensson qyliss ];
    platforms = platforms.linux;
    priority = 10;
  };
}
