{stdenv, fetchurl, enableStatic ? false, extraConfig ? ""}:

let
  configParser = ''
    function parseconfig {
        while read LINE; do
            NAME=`echo "$LINE" | cut -d \  -f 1`
            OPTION=`echo "$LINE" | cut -d \  -f 2`

            if test -z "$NAME"; then
                continue
            fi

            if test "$NAME" == "CLEAR"; then
                echo "parseconfig: CLEAR"
                echo > .config
            fi

            echo "parseconfig: removing $NAME"
            sed -i /$NAME'\(=\| \)'/d .config

            echo "parseconfig: setting $NAME=$OPTION"
            echo "$NAME=$OPTION" >> .config
        done
    }
  '';

  nixConfig = ''
    CONFIG_PREFIX "$out"
    CONFIG_INSTALL_NO_USR y

    # Use the external mount.cifs program.
    CONFIG_FEATURE_MOUNT_CIFS n
    CONFIG_FEATURE_MOUNT_HELPERS y
  '';

  staticConfig = stdenv.lib.optionalString enableStatic ''
    CONFIG_STATIC y
  '';

in

stdenv.mkDerivation rec {
  name = "busybox-1.22.1";

  src = fetchurl {
    url = "http://busybox.net/downloads/${name}.tar.bz2";
    sha256 = "12v7nri79v8gns3inmz4k24q7pcnwi00hybs0wddfkcy1afh42xf";
  };

  configurePhase = ''
    make defconfig
    ${configParser}
    cat << EOF | parseconfig
    ${staticConfig}
    ${nixConfig}
    ${extraConfig}
    $extraCrossConfig
    EOF
    make oldconfig
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
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
