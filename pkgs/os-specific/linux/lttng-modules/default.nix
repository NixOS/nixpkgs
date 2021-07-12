{ lib, stdenv, fetchurl, kernel }:

stdenv.mkDerivation rec {
  pname = "lttng-modules-${kernel.version}";
  version = "2.12.6";

  src = fetchurl {
    url = "https://lttng.org/files/lttng-modules/lttng-modules-${version}.tar.bz2";
    sha256 = "sha256-lawqLPkthdI/+9rKah7A18FnIR0eD7hQq5AASj9HXqo=";
  };

  buildInputs = kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" ];

  NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";

  preConfigure = ''
    export KERNELDIR="${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    export INSTALL_MOD_PATH="$out"
  '';

  installTargets = [ "modules_install" ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Linux kernel modules for LTTng tracing";
    homepage = "https://lttng.org/";
    license = with licenses; [ lgpl21Only gpl2Only mit ];
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
