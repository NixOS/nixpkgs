{ stdenv, lib, fetchFromGitHub, kernel }:

let
  modDestDir = "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/realtek/rtw88";
in
stdenv.mkDerivation {
  pname = "rtw88";
  version = "unstable-2021-04-27";

  src = fetchFromGitHub {
    owner = "lwfinger";
    repo = "rtw88";
    rev = "beaa011f39223e927730e97f7d2df04120713a61";
    hash = "sha256-sQYZQxw2HQ3NzgxykPgkbaU2A6S8w3c7wHpRKN/FvAM=";
  };

  makeFlags = [ "KSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    mkdir -p ${modDestDir}
    find . -name '*.ko' -exec cp --parents {} ${modDestDir} \;
    find ${modDestDir} -name '*.ko' -exec xz -f {} \;

    runHook postInstall
  '';

  meta = with lib; {
    description = "The newest Realtek rtlwifi codes";
    homepage = "https://github.com/lwfinger/rtw88";
    license = with licenses; [ bsd3 gpl2Only ];
    maintainers = with maintainers; [ tvorog ];
    platforms = platforms.linux;
    broken = kernel.kernelOlder "4.14";
    priority = -1;
  };
}
