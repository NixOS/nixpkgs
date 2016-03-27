{ stdenv, fetchurl, kernel }:

stdenv.mkDerivation rec {
  pname = "lttng-modules-${version}";
  name = "${pname}-${kernel.version}";
  version = "2.6.3";

  src = fetchurl {
    url = "http://lttng.org/files/lttng-modules/lttng-modules-${version}.tar.bz2";
    sha256 = "0sk7cyjf5ylmxqrrrz5zmmw4c0dmxh1f98aj870gmcnxfa76y4mx";
  };

  preConfigure = ''
    export KERNELDIR="${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    export INSTALL_MOD_PATH="$out"
  '';

  installPhase = ''
    make modules_install
  '';

  meta = with stdenv.lib; {
    description = "Linux kernel modules for LTTng tracing";
    homepage = http://lttng.org/;
    license = with licenses; [ lgpl21 gpl2 mit ];
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
    broken = (kernel.features.grsecurity or false);
  };

}
