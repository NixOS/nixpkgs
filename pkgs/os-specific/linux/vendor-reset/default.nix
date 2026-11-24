{
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
  lib,
}:

stdenv.mkDerivation {
  pname = "vendor-reset";
  version = "unstable-2026-06-29-${kernel.version}";

  src = fetchFromGitHub {
    owner = "gnif";
    repo = "vendor-reset";
    rev = "cbb4dd50926337e0f9fe1dd1e8a74aa5cb3448a7";
    hash = "sha256-oOiMXIARMSDWm/PChfPV/hJEHe1258Infu4NXC6okn8=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" ];

  makeFlags = kernelModuleMakeFlags ++ [
    "KVER=${kernel.modDirVersion}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    install -D vendor-reset.ko -t "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/misc/"
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Linux kernel vendor specific hardware reset module";
    homepage = "https://github.com/gnif/vendor-reset";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    broken = kernel.kernelOlder "4.19";
  };
}
