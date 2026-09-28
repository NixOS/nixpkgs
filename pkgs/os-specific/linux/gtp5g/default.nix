{
  lib,
  stdenv,
  fetchFromGitHub,

  kmod,
  kernel,
  kernelModuleMakeFlags,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gtp5g";
  version = "0.10.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "free5gc";
    repo = "gtp5g";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GJV7iLCbjHn6YxyWLFqS+EATWdZVbVBoJMZdTVG/8bo=";
  };

  nativeBuildInputs = [ kmod ] ++ kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "KVER=${kernel.modDirVersion}"
  ];

  installPhase = ''
    install -Dm644 gtp5g.ko "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/gtp5g.ko"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GTP-U Linux Kernel Module";
    homepage = "https://free5gc.org/";
    changelog = "https://github.com/free5gc/gtp5g";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ felbinger ];
    broken = lib.versionAtLeast kernel.version "6.18";
  };
})
