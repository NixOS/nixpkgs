{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
  unstableGitUpdater,
}:

let
  modDestDir = "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/realtek/rtw88";
in
stdenv.mkDerivation {
  pname = "rtw88";
  version = "0-unstable-2026-10-24";

  src = fetchFromGitHub {
    owner = "lwfinger";
    repo = "rtw88";
    rev = "f1dd7c3a5b87478ab23c3dbb1f8f0d6b82f3f71c";
    hash = "sha256-KPTfbRW2Hl2EUeY9CkcveBX1mxluJSwf4JWJ+xkwEqE=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;
  makeFlags = kernelModuleMakeFlags ++ [
    "KSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    mkdir -p ${modDestDir}
    find . -name '*.ko' -exec cp --parents {} ${modDestDir} \;
    find ${modDestDir} -name '*.ko' -exec xz -f {} \;

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

  meta = {
    description = "Backport of the latest Realtek RTW88 driver from wireless-next for older kernels";
    homepage = "https://github.com/lwfinger/rtw88";
    license = with lib.licenses; [
      bsd3
      gpl2Only
    ];
    maintainers = with lib.maintainers; [
      tvorog
    ];
    platforms = lib.platforms.linux;
    broken = kernel.kernelOlder "4.20";
    priority = -1;
  };
}
