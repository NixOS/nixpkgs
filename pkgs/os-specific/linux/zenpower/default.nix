{
  lib,
  stdenv,
  kernel,
  kernelModuleMakeFlags,
  fetchFromGitHub,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "zenpower5";
  version = "0.5.0-unstable-2026-01-07";

  src = fetchFromGitHub {
    owner = "mattkeenan";
    repo = "zenpower5";
    rev = "66871d8e59c3741e00de2eb1f61c3b64263ed10b";
    hash = "sha256-g0zVTDi5owa6XfQN8vlFwGX+gpRIg+5q1F4EuxAk9Sk=";
  };

  patches = [
    # https://github.com/mattkeenan/zenpower5/pull/16
    ./kernel-7.2-comp.patch
  ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "KERNEL_BUILD=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=${placeholder "out"}"
    "INSTALL_MOD_DIR=kernel/drivers/hwmon/zenpower"
    "INSTALL_MOD_STRIP=1"
    "DEPMOD=true"
  ];

  installTargets = [ "modules_install" ];

  installFlags = [
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(PWD)"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Linux kernel driver for reading temperature, voltage(SVI2), current(SVI2) and power(SVI2) for AMD Zen family CPUs";
    homepage = "https://github.com/mattkeenan/zenpower5";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      alexbakker
      artturin
    ];
    platforms = [ "x86_64-linux" ];
  };
}
