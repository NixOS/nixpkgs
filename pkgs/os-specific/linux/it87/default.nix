{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
}:

stdenv.mkDerivation rec {
  name = "it87-${version}-${kernel.version}";
  version = "unstable-2025-12-26";

  # Original is no longer maintained.
  # This is the same upstream as the AUR uses.
  src = fetchFromGitHub {
    owner = "frankcrawford";
    repo = "it87";
    rev = "a9eb2495220cba861ef3df63fa15265e878293b6";
    hash = "sha256-iWyOctK+TFhVCOw2LiV4NiNFEAqNXOpSdGY//VwO8Ko=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  preConfigure = ''
    sed -i 's|depmod|#depmod|' Makefile
  '';

  makeFlags = kernelModuleMakeFlags ++ [
    "TARGET=${kernel.modDirVersion}"
    "KERNEL_MODULES=${kernel.dev}/lib/modules/${kernel.modDirVersion}"
    "MODDESTDIR=$(out)/lib/modules/${kernel.modDirVersion}/kernel/drivers/hwmon"
  ];

  meta = {
    description = "Patched module for IT87xx superio chip sensors support";
    homepage = "https://github.com/frankcrawford/it87";
    license = lib.licenses.gpl2Plus;
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
  };
}
