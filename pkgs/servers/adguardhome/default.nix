{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "adguardhome";
  version = "0.105.2";

  src = fetchurl {
    url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v${version}/AdGuardHome_linux_amd64.tar.gz";
    sha256 = "1gpaqyczidsy7h05g318zc83swvwninidddlmlq3hgs8s7ibk2cb";
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
