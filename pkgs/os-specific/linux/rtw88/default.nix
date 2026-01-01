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
<<<<<<< HEAD
  version = "0-unstable-2025-11-30";
=======
  version = "0-unstable-2025-10-20";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "lwfinger";
    repo = "rtw88";
<<<<<<< HEAD
    rev = "3309c45c283cbd996e1e05eeddf90c4fa589b90b";
    hash = "sha256-AtDAzguL71hvgh/xvbBKWmza05n2D5Q+W3YkHQXdup8=";
=======
    rev = "9bc8fecb61d4ad59e46b4dbd003d60ef2d8437a8";
    hash = "sha256-/nA0U1Ry+xt4F4GC9ymMDFhkiHAqeodv7uUXAaALmdg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Backport of the latest Realtek RTW88 driver from wireless-next for older kernels";
    homepage = "https://github.com/lwfinger/rtw88";
    license = with lib.licenses; [
      bsd3
      gpl2Only
    ];
    maintainers = with lib.maintainers; [
      tvorog
      atila
    ];
    platforms = lib.platforms.linux;
=======
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    broken = kernel.kernelOlder "4.20";
    priority = -1;
  };
}
