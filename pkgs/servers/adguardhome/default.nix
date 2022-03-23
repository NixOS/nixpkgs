{ lib, stdenv, fetchurl, fetchzip, nixosTests }:

stdenv.mkDerivation rec {
  pname = "adguardhome";
  version = "0.107.5";

  src = (import ./bins.nix { inherit fetchurl fetchzip; }).${stdenv.hostPlatform.system};

  installPhase = ''
    install -m755 -D ./AdGuardHome $out/bin/adguardhome
  '';

  passthru = {
    updateScript = ./update.sh;
    tests.adguardhome = nixosTests.adguardhome;
  };

  meta = with lib; {
    homepage = "https://github.com/AdguardTeam/AdGuardHome";
    description = "Network-wide ads & trackers blocking DNS server";
    platforms = [ "x86_64-linux" "aarch64-linux" "i686-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ numkem iagoq ];
    license = licenses.gpl3Only;
  };
}
