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

            if test "$OPTION" != n; then
                echo "parseconfig: setting $NAME=$OPTION"
                echo "$NAME=$OPTION" >> .config
            fi
        done
        set +x
    }
  '';

  nixConfig = ''
    CONFIG_PREFIX "$out"
    CONFIG_INSTALL_NO_USR n
  '';

  staticConfig = (if enableStatic then ''
      CONFIG_STATIC y
    '' else "");

in

stdenv.mkDerivation {
  name = "busybox-1.16.0";

  src = fetchurl {
    url = http://busybox.net/downloads/busybox-1.16.0.tar.bz2;
    sha256 = "1n738zk01yi2sjrx2y36hpzxbslas8b91vzykcifr0p1j7ym0lim";
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
