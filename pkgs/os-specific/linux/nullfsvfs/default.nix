{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "nullfsvfs";
  version = "0.28";

  src = fetchFromGitHub {
    owner = "abbbi";
    repo = "nullfsvfs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bKSJRrWpkMvDrsg24ZIDXwed3+rlPyaYkIz4KQ05Q0w=";
  };

  hardeningDisable = [ "pic" ];

  enableParallelBuilding = true;

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "KSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  prePatch = ''
    substituteInPlace "Makefile" \
      --replace-fail "/lib/modules/\$(shell uname -r)/build" "\$(KSRC)"
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}/kernel/fs/nullfsvfs/"
    install -p -m 644 nullfsvfs.ko $out/lib/modules/${kernel.modDirVersion}/kernel/fs/nullfsvfs/
    runHook postInstall
  '';

  meta = {
    broken = kernel.kernelAtLeast "7.4";
    description = "Virtual black hole file system that behaves like /dev/null";
    homepage = "https://github.com/abbbi/nullfsvfs";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ callumio ];
  };
})
