{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "adguardhome";
  version = "0.104.3";

  src = fetchurl {
    url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v${version}/AdGuardHome_linux_amd64.tar.gz";
    sha256 = "0p660d1nvaigyjc39xq5ar775davcbdgf0dh1z6gl3v4gx1h7bkn";
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
