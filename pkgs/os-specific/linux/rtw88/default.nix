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
  version = "0-unstable-2025-07-29";

  src = fetchFromGitHub {
    owner = "lwfinger";
    repo = "rtw88";
    rev = "549f33c361a2569733ba73e47d7e3986ca7e55d6";
    hash = "sha256-gtUo3xo6iwFX203HuUXFbjrprhxvmD9z04yfMKaKIhY=";
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

  meta = with lib; {
    description = "Backport of the latest Realtek RTW88 driver from wireless-next for older kernels";
    homepage = "https://github.com/lwfinger/rtw88";
    license = with licenses; [
      bsd3
      gpl2Only
    ];
    maintainers = with maintainers; [
      tvorog
      atila
    ];
    platforms = platforms.linux;
    broken = kernel.kernelOlder "4.20";
    priority = -1;
  };
}
