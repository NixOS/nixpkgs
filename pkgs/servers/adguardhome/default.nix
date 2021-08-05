{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "adguardhome";
  version = "0.106.3";

  src = fetchurl {
    url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v${version}/AdGuardHome_linux_amd64.tar.gz";
    sha256 = "11p081dqilga61zfziw5w37k6v2r84qynhz2hr4gk8367jck54x8";
  };

  installPhase = ''
    install -m755 -D ./AdGuardHome $out/bin/adguardhome
  '';

  meta = with lib; {
    homepage = "https://github.com/AdguardTeam/AdGuardHome";
    description = "Network-wide ads & trackers blocking DNS server";
    platforms = platforms.linux;
    maintainers = with maintainers; [ numkem ];
    license = licenses.gpl3;
  };
}
