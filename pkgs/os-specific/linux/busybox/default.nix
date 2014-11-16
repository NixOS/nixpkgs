{ lib, stdenv, uclibc, fetchurl, enableStatic ? false, enableMinimal ? false, useUclibc ? false, extraConfig ? "" }:

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
  name = "busybox-1.22.1";

  src = fetchurl {
    url = "http://busybox.net/downloads/${name}.tar.bz2";
    sha256 = "12v7nri79v8gns3inmz4k24q7pcnwi00hybs0wddfkcy1afh42xf";
  };

  patches = [ ./busybox-in-store.patch ];

  configurePhase = ''
    export KCONFIG_NOTIMESTAMP=1
    make ${if enableMinimal then "allnoconfig" else "defconfig"}

    ${configParser}

    cat << EOF | parseconfig

    CONFIG_PREFIX "$out"
    CONFIG_INSTALL_NO_USR y

    ${lib.optionalString enableStatic ''
      CONFIG_STATIC y
    ''}

    # Use the external mount.cifs program.
    CONFIG_FEATURE_MOUNT_CIFS n
    CONFIG_FEATURE_MOUNT_HELPERS y

    ${extraConfig}
    $extraCrossConfig
    EOF

    make oldconfig
  '' + lib.optionalString useUclibc ''
    makeFlagsArray+=("CC=gcc -isystem ${uclibc}/include -B${uclibc}/lib -L${uclibc}/lib")
  '';

  crossAttrs = {
    extraCrossConfig = ''
      CONFIG_CROSS_COMPILER_PREFIX "${stdenv.cross.config}-"
    '' +
      (if stdenv.cross.platform.kernelMajor == "2.4" then ''
        CONFIG_IONICE n
      '' else "");
  };

  enableParallelBuilding = true;

  meta = {
    description = "Tiny versions of common UNIX utilities in a single small executable";
    homepage = http://busybox.net/;
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.viric ];
    platforms = lib.platforms.linux;
  };
}
