{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
  udevCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nxp-pn5xx";
  version = "0-unstable-2026-07-16-${kernel.version}";

  src = fetchFromGitHub {
    owner = "jr64";
    repo = "nxp-pn5xx";
    rev = "6ebc3ce2000dc0ba82bd2f47eb01e69b8ba2dbd0";
    hash = "sha256-rll9NyWZaHFTUIR/jnzZtO3D0Za/i1O+qT6fyvKcYTc=";
  };

  nativeBuildInputs = [ udevCheckHook ] ++ kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "KERNELRELEASE=${kernel.modDirVersion}"
    "BUILD_KERNEL_PATH=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)/lib/modules/${kernel.modDirVersion}"
  ];

  doInstallCheck = true;

  postInstall = ''
    mkdir -p $out/etc/udev/rules.d
    echo 'SUBSYSTEM=="misc", KERNEL=="pn544", MODE="0666", GROUP="dialout"' > $out/etc/udev/rules.d/99-nxp-pn5xx.rules
  '';

  meta = {
    description = "NXP's NFC Open Source Kernel mode driver with ACPI configuration support";
    homepage = "https://github.com/jr64/nxp-pn5xx";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ stargate01 ];
    platforms = lib.platforms.linux;
  };
})
