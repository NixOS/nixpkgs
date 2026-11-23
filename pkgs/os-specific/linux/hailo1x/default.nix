{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
  nix-update-script,
  hailo1x-firmware,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hailo1x";
  version = "5.5.0";
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "hailo-ai";
    repo = "hailort-drivers";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6G7mrxR/8SC5AV00NDvwc3fLBJiXn+68bUv+rFcJjdo=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "INSTALL_MOD_DIR=" "INSTALL_MOD_PATH=${placeholder "out"} INSTALL_MOD_DIR="
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "pcie"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      inherit hailo1x-firmware;
    };
  };

  __structuredAttrs = true;

  meta = {
    description = "Hailo 10/15 PCIe driver";
    homepage = "https://github.com/hailo-ai/hailort-drivers";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ hexa ];
    mainProgram = "hailort-drivers";
    platforms = lib.platforms.all;
  };
})
