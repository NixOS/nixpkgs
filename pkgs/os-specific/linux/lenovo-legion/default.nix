{ lib, stdenv, kernel, bash, lenovo-legion }:

stdenv.mkDerivation {
  pname = "lenovo-legion-module";
  inherit (lenovo-legion) version src;

  sourceRoot = "${lenovo-legion.src.name}/kernel_module";

  hardeningDisable = [ "pic" ];

  preConfigure = ''
    sed -i -e '/depmod/d' ./Makefile
  '';

  makeFlags = kernel.makeFlags ++ [
    "SHELL=bash"
    "KERNELVERSION=${kernel.modDirVersion}"
    "KSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALLDIR=${placeholder "out"}/lib/modules/${kernel.modDirVersion}/kernel/drivers/platform/x86"
    "MODDESTDIR=${placeholder "out"}/lib/modules/${kernel.modDirVersion}/kernel/drivers/platform/x86"
    "DKMSDIR=${placeholder "out"}/lib/modules/${kernel.modDirVersion}/misc"
  ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  meta = {
    description = "Linux kernel module for controlling fan and power in Lenovo Legion laptops";
    homepage = "https://github.com/johnfanv2/LenovoLegionLinux";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.ulrikstrid ];
    broken = kernel.kernelOlder "5.15";
  };
}
