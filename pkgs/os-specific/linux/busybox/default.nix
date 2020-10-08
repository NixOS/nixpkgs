{ stdenv, lib, buildPackages, fetchurl, fetchFromGitLab
, enableStatic ? false
, enableMinimal ? false
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

  # The debian version lacks behind the upstream version and also contains
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
  # TODO: When bumping this version, please validate whether the wget patch is present upstream
  # and remove the patch if it is. The patch should be present upstream for all versions 1.32.0+.
  # See NixOs/nixpkgs#94722 for context.
  name = "busybox-1.31.1";

  # Note to whoever is updating busybox: please verify that:
  # nix-build pkgs/stdenv/linux/make-bootstrap-tools.nix -A test
  # still builds after the update.
  src = fetchurl {
    url = "https://busybox.net/downloads/${name}.tar.bz2";
    sha256 = "1659aabzp8w4hayr4z8kcpbk2z1q2wqhw7i1yb0l72b45ykl1yfh";
  };

  hardeningDisable = [ "format" "pie" ]
    ++ lib.optionals enableStatic [ "fortify" ];

  patches = [
    ./busybox-in-store.patch
    ./0001-Fix-build-with-glibc-2.31.patch
    ./0001-wget-implement-TLS-verification-with-ENABLE_FEATURE_.patch
  ] ++ stdenv.lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) ./clang-cross.patch;

  postPatch = "patchShebangs .";

  configurePhase = ''
    export KCONFIG_NOTIMESTAMP=1
    make ${if enableMinimal then "allnoconfig" else "defconfig"}

    ${configParser}

    cat << EOF | parseconfig

    CONFIG_PREFIX "$out"
    CONFIG_INSTALL_NO_USR y

    CONFIG_LFS y

    ${lib.optionalString enableStatic ''
      CONFIG_STATIC y
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

  postInstall = ''
    sed -e '
    1 a busybox() { '$out'/bin/busybox "$@"; }\
    logger() { '$out'/bin/logger "$@"; }\
    ' ${debianDispatcherScript} > ${outDispatchPath}
    chmod 555 ${outDispatchPath}
    PATH=$out/bin patchShebangs ${outDispatchPath}
  '';

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  buildInputs = lib.optionals (enableStatic && !useMusl && stdenv.cc.libc ? static) [ stdenv.cc.libc stdenv.cc.libc.static ];

  enableParallelBuilding = true;

  doCheck = false; # tries to access the net

  meta = with stdenv.lib; {
    description = "Tiny versions of common UNIX utilities in a single small executable";
    homepage = "https://busybox.net/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ TethysSvensson ];
    platforms = platforms.linux;
    priority = 10;
  };
}
