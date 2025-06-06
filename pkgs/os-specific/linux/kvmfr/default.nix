{ lib, stdenv, kernel, looking-glass-client }:

stdenv.mkDerivation {
  pname = "kvmfr";
  version = looking-glass-client.version;

  src = looking-glass-client.src;
  sourceRoot = "${looking-glass-client.src.name}/module";
  hardeningDisable = [ "pic" "format" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "KVER=${kernel.modDirVersion}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    install -D kvmfr.ko -t "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/misc/"
  '';

  meta = with lib; {
    description = "Optional kernel module for LookingGlass";
    longDescription = ''
      This kernel module implements a basic interface to the IVSHMEM device for LookingGlass when using LookingGlass in VM->VM mode
      Additionally, in VM->host mode, it can be used to generate a shared memory device on the host machine that supports dmabuf
    '';
    homepage = "https://github.com/gnif/LookingGlass";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ j-brn ];
    platforms = [ "x86_64-linux" ];
    broken = kernel.kernelOlder "5.3";
  };
}
