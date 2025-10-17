{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
}:

let
  modDestDir = "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/realtek/rtw89";
in
stdenv.mkDerivation {
  pname = "rtw89";
  version = "unstable-2022-12-18";

  src = fetchFromGitHub {
    owner = "lwfinger";
    repo = "rtw89";
    rev = "e834edfe8bee6e27e31c2f783817a9c13ff45665";
    sha256 = "19ApYiEvA0E6qgf5XQc03paZ+ghjZL8JoC3vSYYw3xU=";
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

  meta = with lib; {
    description = "Driver for Realtek 8852AE, 8852BE, and 8853CE, 802.11ax devices";
    homepage = "https://github.com/lwfinger/rtw89";
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [ tvorog ];
    platforms = platforms.linux;
    broken = kernel.kernelOlder "5.7";
    priority = -1;
  };
}
