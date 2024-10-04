{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation {
  pname = "bitcraze-udev-rules";
  version = "0.1.23";

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm444 ${./99-bitcraze.rules} $out/lib/udev/rules.d/99-bitcraze.rules

    runHook postInstall
  '';

  meta = with lib; {
    description = "Udev rules for Bitcraze Crazyflie";
    license = licenses.gpl2;
    maintainers = with maintainers; [
      vbruegge
      stargate01
    ];
    platforms = platforms.linux;
    homepage = "https://github.com/bitcraze/crazyflie-lib-python/blob/master/docs/installation/usb_permissions.md";
  };
}
