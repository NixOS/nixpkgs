{ lib, stdenv, fetchurl, fetchzip, system ? stdenv.targetPlatform }:

stdenv.mkDerivation rec {
  pname = "adguardhome";
  version = "0.106.3";

  src = (import ./bins.nix { inherit fetchurl fetchzip; }).${system};

  installPhase = ''
    install -m755 -D ./AdGuardHome $out/bin/adguardhome
  '';

  meta = with lib; {
    homepage = "https://github.com/AdguardTeam/AdGuardHome";
    description = "Network-wide ads & trackers blocking DNS server";
    platforms = platforms.unix;
    maintainers = with maintainers; [ numkem iagoq ];
    license = licenses.gpl3Only;
  };
}
