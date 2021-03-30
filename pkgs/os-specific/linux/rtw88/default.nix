{ stdenv, lib, fetchFromGitHub, kernel }:

let
  modDestDir = "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/realtek/rtw88";
in
stdenv.mkDerivation {
  pname = "rtw88";
  version = "unstable-2021-03-21";

  src = fetchFromGitHub {
    owner = "lwfinger";
    repo = "rtw88";
    rev = "fb2d8d2be9b33328eaf391926c502b34f6367b01";
    hash = "sha256-NjB0eooI6j6IDtD572ZkairPdJwc/x+pxITLb7ujoS8=";
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
