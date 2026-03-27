{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
}:
stdenv.mkDerivation rec {
  pname = "nullfs";
  version = "0.22";

  src = fetchFromGitHub {
    owner = "abbbi";
    repo = "nullfsvfs";
    rev = "v${version}";
    sha256 = "sha256-UJubWx5QfzLAiYTN1BPaziT3gKsTI0OVCmcuwKX3Gp0=";
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
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}/kernel/fs/nullfs/"
    install -p -m 644 nullfs.ko $out/lib/modules/${kernel.modDirVersion}/kernel/fs/nullfs/
    runHook postInstall
  '';

  meta = {
    description = "Virtual black hole file system that behaves like /dev/null";
    homepage = "https://github.com/abbbi/nullfsvfs";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ callumio ];
  };
}
