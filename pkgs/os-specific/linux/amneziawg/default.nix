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
  version = "3.1.20260827";

  src = fetchFromGitHub {
    owner = "amnezia-vpn";
    repo = "amneziawg-linux-kernel-module";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jRpYf3J6lVWgo+TNOz1Np27RAYc6Ap22Iu9T2NM0lyU=";
  };

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
