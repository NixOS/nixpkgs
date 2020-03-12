{ stdenv, fetchurl, kernel }:

stdenv.mkDerivation rec {
  pname = "lttng-modules-${version}";
  name = "${pname}-${kernel.version}";
  version = "2.10.5";

  src = fetchurl {
    url = "https://lttng.org/files/lttng-modules/lttng-modules-${version}.tar.bz2";
    sha256 = "07rs01zwr4bmjamplix5qz1c6mb6wdawb68vyn0w6wx68ppbpnxq";
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

  meta = with stdenv.lib; {
    description = "Linux kernel modules for LTTng tracing";
    homepage = https://lttng.org/;
    license = with licenses; [ lgpl21 gpl2 mit ];
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
    broken = builtins.compareVersions kernel.version "3.18" == -1
      || builtins.compareVersions kernel.version "4.16" == 1;
  };

}
