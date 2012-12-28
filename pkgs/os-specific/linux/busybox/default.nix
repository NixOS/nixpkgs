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
  '';

  staticConfig = stdenv.lib.optionalString enableStatic ''
    CONFIG_STATIC y
  '';

in

stdenv.mkDerivation rec {
  name = "busybox-1.20.2";

  src = fetchurl {
    url = "http://busybox.net/downloads/${name}.tar.bz2";
    sha256 = "10k8kgrprll9hxfm9gc3jl7kkq79g6l2pygn5snqwqg5v80zy4zb";
  };

  # Remove this patch after the next busybox update.
  patches = [ ./include-missing-sys-resource-header.patch ];

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
      (if stdenv.cross.platform.kernelMajor == "2.4" then ''
        CONFIG_IONICE n
      '' else "");
  };

  enableParallelBuilding = true;

  meta = {
    description = "Tiny versions of common UNIX utilities in a single small executable";
    homepage = http://busybox.net/;
    license = "GPLv2";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
