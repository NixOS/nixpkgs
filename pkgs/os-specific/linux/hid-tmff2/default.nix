{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
  unstableGitUpdater,
}:
stdenv.mkDerivation {
  pname = "hid-tmff2";
  # https://github.com/Kimplul/hid-tmff2/blob/ca168637fbfb085ebc9ade0c47fa0653dac5d25b/dkms/dkms-install.sh#L12
  version = "0.83-unstable-2026-11-23";

  src = fetchFromGitHub {
    owner = "Kimplul";
    repo = "hid-tmff2";
    rev = "de19c2c3a18e9d1d3dc4e89eae13d8413e3353d2";
    hash = "sha256-i/OTPiNnwxVm6/+8rD13SfpV/i5s2h4W7nopV8doRWg=";
    # For hid-tminit. Source: https://github.com/scarburato/hid-tminit
    fetchSubmodules = true;
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installFlags = [
    "INSTALL_MOD_PATH=${placeholder "out"}"
  ];

  passthru.updateScript = unstableGitUpdater { };

  postPatch = "sed -i '/depmod -A/d' Makefile";

  meta = {
    description = "Linux kernel module for Thrustmaster T300RS, T248 and TX(experimental)";
    homepage = "https://github.com/Kimplul/hid-tmff2";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.rayslash ];
    platforms = lib.platforms.linux;
  };
}
