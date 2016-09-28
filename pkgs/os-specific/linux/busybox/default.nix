{ stdenv, lib, fetchurl, glibc, musl
, enableStatic ? false
, enableMinimal ? false
, useMusl ? false
, extraConfig ? ""
}:

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

in

stdenv.mkDerivation rec {
  name = "busybox-1.24.2";

  src = fetchurl {
    url = "http://busybox.net/downloads/${name}.tar.bz2";
    sha256 = "0mf8f6ly8yi1fbr15jkyv6hxwh2x800x661rcd11rwsnqqzga7p7";
  };

  hardeningDisable = [ "format" ] ++ lib.optional enableStatic [ "fortify" ];

  patches = [ ./busybox-in-store.patch ];

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

    ${extraConfig}
    $extraCrossConfig
    EOF

    make oldconfig

    runHook postConfigure
  '';

  postConfigure = lib.optionalString useMusl ''
    makeFlagsArray+=("CC=gcc -isystem ${musl}/include -B${musl}/lib -L${musl}/lib")
  '';

  buildInputs = lib.optionals (enableStatic && !useMusl) [ stdenv.cc.libc stdenv.cc.libc.static ];

  crossAttrs = {
    extraCrossConfig = ''
      CONFIG_CROSS_COMPILER_PREFIX "${stdenv.cross.config}-"
    '';

    postConfigure = stdenv.lib.optionalString useMusl ''
      makeFlagsArray+=("CC=$crossConfig-gcc -isystem ${musl.crossDrv}/include -B${musl.crossDrv}/lib -L${musl.crossDrv}/lib")
    '';
  };

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Tiny versions of common UNIX utilities in a single small executable";
    homepage = http://busybox.net/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ viric ];
    platforms = platforms.linux;
  };
}
