{ stdenv, lib, fetchFromGitHub, kernel }:

let
  modDestDir = "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/realtek/rtw89";
in
stdenv.mkDerivation {
  pname = "rtw89";
  version = "unstable-2021-07-03";

  src = fetchFromGitHub {
    owner = "lwfinger";
    repo = "rtw89";
    rev = "cebafc6dc839e66c725b92c0fabf131bc908f607";
    sha256 = "1vw67a423gajpzd5d51bxnja1qpppx9x5ii2vcfkj6cbnqwr83af";
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
    description = " Driver for Realtek 8852AE, an 802.11ax device";
    homepage = "https://github.com/lwfinger/rtw89";
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [ tvorog ];
    platforms = platforms.linux;
    broken = kernel.kernelOlder "5.4";
    priority = -1;
  };
}
