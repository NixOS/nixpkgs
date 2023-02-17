{ stdenvNoCC, lib, fetchFromGitHub }:

stdenvNoCC.mkDerivation {
  pname = "rtw89-firmware";

  # TODO: probably remove after updating linux firmware
  # https://github.com/lwfinger/rtw89/commit/a2c113501a5a988683f236df1aa79ce40f29e1be
  version = "unstable-2021-10-21";

  src = fetchFromGitHub {
    owner = "lwfinger";
    repo = "rtw89";
    rev = "0684157cba90e36bff5bc61a59e7e87c359b5e5c";
    sha256 = "0cvawyi1ksw9xkr8pzwipsl7b8hnmrb17w5cblyicwih8fqaw632";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/firmware/rtw89
    cp *.bin $out/lib/firmware/rtw89

    runHook postInstall
  '';

  meta = with lib; {
    description = "Driver for Realtek 8852AE, an 802.11ax device";
    homepage = "https://github.com/lwfinger/rtw89";
    license = licenses.unfreeRedistributableFirmware;
    maintainers = with maintainers; [ tvorog ];
    platforms = platforms.linux;
  };
}
