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
  version = "0.83-unstable-2026-08-09";

  src = fetchFromGitHub {
    owner = "Kimplul";
    repo = "hid-tmff2";
    rev = "c5b9b79d4e61b77e0827e81dd676420b3c366743";
    hash = "sha256-Su4Qr3z28luv+uxvCAfMVtTXVxJUuAj7K0b5F3OTmfs=";
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
