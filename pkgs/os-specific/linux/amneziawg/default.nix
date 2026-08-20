{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "amneziawg";
  version = "3.1.20260812";

  src = fetchFromGitHub {
    owner = "amnezia-vpn";
    repo = "amneziawg-linux-kernel-module";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dJ7Au4J8iPlphSzTa3Gol/LMlroroSc2IUmXZfjA0k8=";
  };

  patches = [
    # Compatibility fixes for kernel 7.1.5+, 7.2
    # Submitted upstream: https://github.com/amnezia-vpn/amneziawg-linux-kernel-module/pull/194
    ./sk-715.patch
  ];

  sourceRoot = "${finalAttrs.src.name}/src";
  hardeningDisable = [ "pic" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  buildFlags = [
    "module"
  ];

  makeFlags = kernelModuleMakeFlags ++ [
    "KERNELDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  enableParallelBuilding = true;

  installFlags = [
    "DEPMOD=true"
    "INSTALL_MOD_PATH=${placeholder "out"}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Kernel module for the AmneziaWG";
    homepage = "https://amnezia.org";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ averyanalex ];
    platforms = lib.platforms.linux;
  };
})
