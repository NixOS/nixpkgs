{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "adguardhome";
  version = "0.101.0";

  src = fetchurl {
    url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v${version}/AdGuardHome_linux_amd64.tar.gz";
    sha256 = "17k37hh04zhy5csl0p9g4hybfc403i38n754in1xrkzxi81r8dh5";
  };

  installPhase = ''
    install -m755 -D ./AdGuardHome $out/bin/adguardhome
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/AdguardTeam/AdGuardHome";
    description = "Network-wide ads & trackers blocking DNS server";
    platforms = platforms.linux;
    maintainers = with maintainers; [ numkem ];
    license = licenses.gpl3;
  };
}
