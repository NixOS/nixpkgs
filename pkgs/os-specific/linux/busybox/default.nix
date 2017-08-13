{ stdenv, lib, buildPackages, fetchurl
, enableStatic ? false
, enableMinimal ? false
, useMusl ? false, musl
, extraConfig ? ""
, buildPlatform, hostPlatform
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
  name = "busybox-1.26.2";

  src = fetchurl {
    url = "http://busybox.net/downloads/${name}.tar.bz2";
    sha256 = "05mg6rh5smkzfwqfcazkpwy6h6555llsazikqnvwkaf17y8l8gns";
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
    CONFIG_CROSS_COMPILER_PREFIX "${stdenv.cc.prefix}"
    EOF

    make oldconfig

    runHook postConfigure
  '';

  postConfigure = lib.optionalString useMusl ''
    makeFlagsArray+=("CC=${stdenv.cc.prefix}gcc -isystem ${musl}/include -B${musl}/lib -L${musl}/lib")
  '';

  nativeBuildInputs = lib.optional (hostPlatform != buildPlatform) buildPackages.stdenv.cc;

  buildInputs = lib.optionals (enableStatic && !useMusl) [ stdenv.cc.libc stdenv.cc.libc.static ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Tiny versions of common UNIX utilities in a single small executable";
    homepage = https://busybox.net/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ viric ];
    platforms = platforms.linux;
  };
}
