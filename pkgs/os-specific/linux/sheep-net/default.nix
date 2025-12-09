{
  kernel,
  kernelModuleMakeFlags,
  stdenv,
  basiliskii,
  lib,
}:
stdenv.mkDerivation (finalAttrs: {
  name = "sheep_net";
  version = basiliskii.version;
  src = basiliskii.src;
  sourceRoot = "${finalAttrs.src.name}/BasiliskII/src/Unix/Linux/NetDriver";

  nativeBuildInputs = kernel.moduleBuildDependencies;
  makeFlags = kernelModuleMakeFlags ++ [
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}"
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/drivers/net
    install -Dm444 sheep_net.ko $out/lib/modules/${kernel.modDirVersion}/drivers/net/sheep_net.ko
    runHook postInstall
  '';

  meta = {
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    platforms = lib.platforms.linux;
  };
})
