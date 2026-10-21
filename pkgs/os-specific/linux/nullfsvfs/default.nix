{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
  kernelModuleInstallHook,
  kernelModuleMakeFlags,
}:
stdenv.mkDerivation rec {
  pname = "nullfsvfs";
  version = "0.27";

  src = fetchFromGitHub {
    owner = "abbbi";
    repo = "nullfsvfs";
    rev = "v${version}";
    sha256 = "sha256-BvixSZN9GqFS4llaiKHfkLb21+qG74YtyNb8bUP0jdU=";
  };

  hardeningDisable = [ "pic" ];

  enableParallelBuilding = true;

  nativeBuildInputs = kernel.moduleBuildDependencies ++ [ kernelModuleInstallHook ];

  makeFlags = kernelModuleMakeFlags ++ [
    "KSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  prePatch = ''
    substituteInPlace "Makefile" \
      --replace-fail "/lib/modules/\$(shell uname -r)/build" "\$(KSRC)"
  '';

  kernelModuleInstallDir = "kernel/fs/nullfsvfs";

  meta = {
    description = "Virtual black hole file system that behaves like /dev/null";
    homepage = "https://github.com/abbbi/nullfsvfs";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ callumio ];
  };
}
