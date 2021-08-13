{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "openelec-dvb-firmware";
  version = "0.0.51";

  src = fetchurl {
    url = "https://github.com/OpenELEC/dvb-firmware/archive/${version}.tar.gz";
    sha256 = "cef3ce537d213e020af794cecf9de207e2882c375ceda39102eb6fa2580bad8d";
  };

  installPhase = ''
    runHook preInstall

    DESTDIR="$out" ./install
    find $out \( -name 'README.*' -or -name 'LICEN[SC]E.*' -or -name '*.txt' \) | xargs rm

    runHook postInstall
  '';

  meta = with lib; {
    description = "DVB firmware from OpenELEC";
    homepage = "https://github.com/OpenELEC/dvb-firmware";
    license = licenses.unfreeRedistributableFirmware;
    platforms = platforms.linux;
    priority = 7;
  };
}
