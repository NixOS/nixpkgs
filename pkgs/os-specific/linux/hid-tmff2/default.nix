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
  version = "0-unstable-2025-04-22";

  src = fetchFromGitHub {
    owner = "Kimplul";
    repo = "hid-tmff2";
    rev = "d4c9e065ca41b30e1cb7a9852ba182b53a669b9c";
    hash = "sha256-SACkTzj3CFiU8HllW82oXtGF+BEH332AcC4w+ghwtjk=";
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

  meta = with lib; {
    description = "Linux kernel module for Thrustmaster T300RS, T248 and TX(experimental)";
    homepage = "https://github.com/Kimplul/hid-tmff2";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.rayslash ];
    platforms = platforms.linux;
  };
}
