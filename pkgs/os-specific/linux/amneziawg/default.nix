{
  lib,
  stdenv,
  fetchFromGitHub,
  srcOnly,
  kernel,
  kernelModuleMakeFlags,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "amneziawg";
  version = "1.0.20241112";

  src = fetchFromGitHub {
    owner = "amnezia-vpn";
    repo = "amneziawg-linux-kernel-module";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Zi70d1l13kLLOSZj4fiq5urijFDPsFDbWT9tcFn34Cc=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";
  hardeningDisable = [ "pic" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  buildFlags = [
    "apply-patches"
    "module"
  ];

  makeFlags =
    kernelModuleMakeFlags
    ++ [ "KERNELDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" ]
    ++ lib.optional (lib.versionAtLeast kernel.version "5.6") "KERNEL_SOURCE_DIR=${srcOnly kernel}";

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
