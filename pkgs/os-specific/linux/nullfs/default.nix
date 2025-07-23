{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
}:
stdenv.mkDerivation rec {
  pname = "nullfs";
  version = "0.19";

  src = fetchFromGitHub {
    owner = "abbbi";
    repo = "nullfsvfs";
    rev = "v${version}";
    sha256 = "sha256-nEwLxcELLBd+BN7OHYLJZCpie0rG0a1wj0RCOKpZkRU=";
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

  meta = with lib; {
    description = "Virtual black hole file system that behaves like /dev/null";
    homepage = "https://github.com/abbbi/nullfsvfs";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ callumio ];
  };
}
