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

  patches = [
    ./module_init.patch
  ];

  installPhase = ''
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/drivers/net
    install -Dm444 sheep_net.ko $out/lib/modules/${kernel.modDirVersion}/drivers/net/sheep_net.ko
  '';

  meta = with lib; {
    license = licenses.gpl2;
    maintainers = with maintainers; [ matthewcroughan ];
    platforms = platforms.linux;
  };
})
