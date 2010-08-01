{stdenv, fetchurl, enableStatic ? false, extraConfig ? ""}:

let
  configParser = ''
    function parseconfig {
        set -x
        while read LINE; do
            NAME=`cut -d \  -f 1 $LINE`
            OPTION=`cut -d \  -f 2 $LINE`

            if test -z "$NAME"; then
                continue
            fi

            if test "$NAME" == "CLEAR"; then
                echo > .config
            fi

            sed -i /^$NAME=/d .config

            if test "$OPTION" != n; then
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
      sed -i 's,.*CONFIG_STATIC.*,CONFIG_STATIC=y,' .config
    '' else "");

in

stdenv.mkDerivation {
  name = "busybox-1.16.0";

  src = fetchurl {
    url = http://busybox.net/downloads/busybox-1.16.0.tar.bz2;
    sha256 = "1n738zk01yi2sjrx2y36hpzxbslas8b91vzykcifr0p1j7ym0lim";
  };

  configurePhase = ''
    set -x
    make defconfig
    ${configParser}
    cat << EOF | parseconfig
    ${extraConfig}
    ${nixConfig}
    $extraCrossConfig
    EOF
    set +x
  '';

  crossAttrs = {
    extraCrossConfig = ''
      CONFIG_CROSS_COMPILER_PREFIX "$crossConfig-"
    '' +
      (if (stdenv.cross.platform.kernelMajor == "2.4") then ''
        CONFIG_IONICE n
      '' else "");
  };
}
