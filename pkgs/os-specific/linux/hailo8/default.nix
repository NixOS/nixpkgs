{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
  nix-update-script,
  hailo8-firmware,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hailo8";
  version = "4.24.0";
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "hailo-ai";
    repo = "hailort-drivers";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2yEKd6n/qReRXGIGMp3LjE0hM32qvaqOiIFxhT5h+yQ=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(PWD)/linux/pcie"
    "INSTALL_MOD_PATH=${placeholder "out"}"
    "INSTALL_MOD_DIR=extra"
  ];

  installTargets = [ "modules_install" ];

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        # 4.x versions track hailo8, later versions track newer hardware.
        "--version-regex"
        "v(4\\.[0-9]+\\.[0-9]+)$"
        "--subpackage"
        "tests.hailo8-firmware"
      ];
    };
    tests = {
      inherit hailo8-firmware;
    };
  };

  __structuredAttrs = true;

  meta = {
    description = "Hailo 8 PCIe driver";
    homepage = "https://github.com/hailo-ai/hailort-drivers";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      hexa
      aaravrav
    ];
    platforms = lib.platforms.linux;
  };
})
