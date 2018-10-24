{ stdenv, lib, buildPackages, fetchurl
, enableStatic ? false
, enableMinimal ? false
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
in

stdenv.mkDerivation rec {
  name = "busybox-1.29.3";

  # Note to whoever is updating busybox: please verify that:
  # nix-build pkgs/stdenv/linux/make-bootstrap-tools.nix -A test
  # still builds after the update.
  src = fetchurl {
    url = "https://busybox.net/downloads/${name}.tar.bz2";
    sha256 = "1dzg45vgy2w1xcd3p6h8d76ykhabbvk1h0lf8yb24ikrwlv8cr4p";
  };

  hardeningDisable = [ "format" ] ++ lib.optionals enableStatic [ "fortify" ];

  patches = [
    ./busybox-in-store.patch
  ];

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

    ${extraConfig}
    CONFIG_CROSS_COMPILER_PREFIX "${stdenv.cc.targetPrefix}"
    ${libcConfig}
    EOF

    make oldconfig

    runHook postConfigure
  '';

  postConfigure = lib.optionalString useMusl ''
    makeFlagsArray+=("CC=${stdenv.cc.targetPrefix}cc -isystem ${musl.dev}/include -B${musl}/lib -L${musl}/lib")
  '';

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  buildInputs = lib.optionals (enableStatic && !useMusl) [ stdenv.cc.libc stdenv.cc.libc.static ];

  enableParallelBuilding = true;

  doCheck = false; # tries to access the net

  meta = with stdenv.lib; {
    description = "Tiny versions of common UNIX utilities in a single small executable";
    homepage = https://busybox.net/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
