{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "adguardhome";
  version = "0.102.0";

  src = fetchurl {
    url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v${version}/AdGuardHome_linux_amd64.tar.gz";
    sha256 = "192v3k0q8qdr52a34bf48i8rvm41wgi6an8a4rcsgyq5j8l7v76i";
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
