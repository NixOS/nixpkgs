{ stdenv, fetchurl, kernel }:

stdenv.mkDerivation rec {
  pname = "lttng-modules-${version}";
  name = "${pname}-${kernel.version}";
  version = "2.9.3";

  src = fetchurl {
    url = "http://lttng.org/files/lttng-modules/lttng-modules-${version}.tar.bz2";
    sha256 = "1zms8q199489ym0x1ri54napyi6pva80641x9x3qg9q23flbq4gr";
  };

  hardeningDisable = [ "pic" ];

  NIX_CFLAGS_COMPILE = [ "-Wno-error=implicit-function-declaration" ];

  preConfigure = ''
    export KERNELDIR="${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    export INSTALL_MOD_PATH="$out"
  '';

  installTargets = [ "modules_install" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Linux kernel modules for LTTng tracing";
    homepage = http://lttng.org/;
    license = with licenses; [ lgpl21 gpl2 mit ];
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
    broken =
      (builtins.compareVersions kernel.version "3.18" == -1) ||
      (kernel.features.chromiumos or false);
  };

}
