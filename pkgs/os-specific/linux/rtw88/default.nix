{ stdenv, lib, fetchFromGitHub, kernel }:

let
  modDestDir = "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/realtek/rtw88";
in
stdenv.mkDerivation {
  pname = "rtw88";
  version = "unstable-2021-04-19";

  src = fetchFromGitHub {
    owner = "lwfinger";
    repo = "rtw88";
    rev = "0f3cc6a5973bc386d9cb542fc85a6ba027edff5d";
    hash = "sha256-PRzWXC1lre8gt1GfVdnaG836f5YK57P9a8tG20yef0w=";
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
    description = "The newest Realtek rtlwifi codes";
    homepage = "https://github.com/lwfinger/rtw88";
    license = with licenses; [ bsd3 gpl2Only ];
    maintainers = with maintainers; [ tvorog ];
    platforms = platforms.linux;
    broken = kernel.kernelOlder "4.14" || kernel.kernelAtLeast "5.14";
    priority = -1;
  };
}
