{ stdenv, lib, fetchFromGitHub, kernel }:

let
  modDestDir = "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/realtek/rtw88";
in
stdenv.mkDerivation {
  pname = "rtw88";
  version = "unstable-2022-11-05";

  src = fetchFromGitHub {
    owner = "lwfinger";
    repo = "rtw88";
    rev = "c0dfe571fd7b307e036f186ef5711b4c0d9f3f08";
    sha256 = "1gc5nv5pyrfag826z36vsrbirg6iww99yx45pcgpp7rmrpbwamvg";
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
    maintainers = with maintainers; [ tvorog atila ];
    platforms = platforms.linux;
    broken = kernel.kernelOlder "4.20";
    priority = -1;
  };
}
