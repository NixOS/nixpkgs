{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hailort-1x";
  version = "4.24.0";
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "hailo-ai";
    repo = "hailort-drivers";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2yEKd6n/qReRXGIGMp3LjE0hM32qvaqOiIFxhT5h+yQ=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  buildPhase = ''
    runHook preBuild

    make -C linux/pcie all \
      KERNEL_DIR="${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D \
      $(find linux/pcie/build -name hailo_pci.ko -print -quit) \
      $out/lib/modules/${kernel.modDirVersion}/extra/hailo_pci.ko

    runHook postInstall
  '';


  passthru.updateScript = nix-update-script {
     # 4.x versions track hailo8, later versions track newer hardware
    extraArgs = [ "--version-regex '^4\\..*$'" ];
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
