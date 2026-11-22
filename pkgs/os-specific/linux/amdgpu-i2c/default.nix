{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
}:

let
  KDIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
in
stdenv.mkDerivation {
  pname = "amdgpu-i2c";
  version = "0-unstable-2024-12-16";

  src = fetchFromGitHub {
    owner = "twifty";
    repo = "amd-gpu-i2c";
    rev = "06ca41fd12fb90f970d3ebd4785cc26cc0a3f3b0";
    sha256 = "sha256-GVyrwnwNSBW4OCNDqQMU6e31C4bG14arC0MPkRWfiJQ=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "KVER=${kernel.modDirVersion}"
    "KDIR=${KDIR}"
    "INSTALL_MOD_PATH=${placeholder "out"}"
    "INSTALL_MOD_DIR=updates"
  ];

  buildPhase = "make -C ${KDIR} M=/build/source modules";

  installTargets = [ "modules_install" ];

  installFlags = [
    "-C"
    "${KDIR}"
    "M=$(PWD)"
  ];

  meta = {
    homepage = "https://github.com/twifty/amd-gpu-i2c";
    downloadPage = "https://github.com/twifty/amd-gpu-i2c";
    description = "Exposes i2c interface to set colors on AMD GPUs";
    broken = kernel.kernelOlder "6.1.0";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ thardin ];
  };
}
