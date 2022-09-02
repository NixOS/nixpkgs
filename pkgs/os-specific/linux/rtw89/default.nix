{ stdenv, lib, fetchFromGitHub, kernel }:

let
  modDestDir = "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/realtek/rtw89";
in
stdenv.mkDerivation {
  pname = "rtw89";
  version = "unstable-2021-10-21";

  src = fetchFromGitHub {
    owner = "lwfinger";
    repo = "rtw89";
    rev = "0684157cba90e36bff5bc61a59e7e87c359b5e5c";
    sha256 = "0cvawyi1ksw9xkr8pzwipsl7b8hnmrb17w5cblyicwih8fqaw632";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;
  makeFlags = kernel.makeFlags ++ [ "KSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    mkdir -p ${modDestDir}
    find . -name '*.ko' -exec cp --parents {} ${modDestDir} \;
    find ${modDestDir} -name '*.ko' -exec xz -f {} \;

    runHook postInstall
  '';

  meta = with lib; {
    description = " Driver for Realtek 8852AE, an 802.11ax device";
    homepage = "https://github.com/lwfinger/rtw89";
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [ tvorog ];
    platforms = platforms.linux;
    broken = kernel.kernelOlder "5.4";
    priority = -1;
  };
}
