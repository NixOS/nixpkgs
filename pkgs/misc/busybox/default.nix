{stdenv, fetchurl, enableStatic ? false, extraConfig ? ""}:

let
  configParser = ''
    function parseconfig {
        set -x
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
            sed -i /^$NAME=/d .config

            echo "parseconfig: setting $NAME=$OPTION"
            echo "$NAME=$OPTION" >> .config
        done
        set +x
    }
  '';

  nixConfig = ''
    CONFIG_PREFIX "$out"
    CONFIG_INSTALL_NO_USR y
  '';

  staticConfig = (if enableStatic then ''
      CONFIG_STATIC y
    '' else "");

in

stdenv.mkDerivation rec {
  name = "busybox-1.19.0";

  src = fetchurl {
    url = "http://busybox.net/downloads/${name}.tar.bz2";
    sha256 = "0332yxvlfv2hbix9n70dyp4xlm2hrk248qqdg006hyfpjsh49kqr";
  };

  configurePhase = ''
    make defconfig
    ${configParser}
    cat << EOF | parseconfig
    ${staticConfig}
    ${extraConfig}
    ${nixConfig}
    $extraCrossConfig
    EOF
    make oldconfig
  '';

  crossAttrs = {
    extraCrossConfig = ''
      CONFIG_CROSS_COMPILER_PREFIX "${stdenv.cross.config}-"
    '' +
      (if (stdenv.cross.platform.kernelMajor == "2.4") then ''
        CONFIG_IONICE n
      '' else "");
  };
}
