{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
  bc,
}:

let
  modDestDir = "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/realtek/rtl8192eu";

in
stdenv.mkDerivation {
  pname = "rtl8192eu";
  version = "${kernel.version}-4.4.1.20250504";

  src = fetchFromGitHub {
    owner = "Mange";
    repo = "rtl8192eu-linux-driver";
    rev = "27aa922c298f2be240eec6c2e8636fe865ece195";
    sha256 = "sha256-1Kz/GgsHsEgrp+1x2rLpJpo98Ur16aWf9CV0gcYmp0Q=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies ++ [ bc ];

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

  meta = with lib; {
    description = "Realtek rtl8192eu driver";
    homepage = "https://github.com/Mange/rtl8192eu-linux-driver";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    broken = stdenv.hostPlatform.isAarch64 || kernel.kernelAtLeast "6.17";
    maintainers = with maintainers; [ troydm ];
  };
}
