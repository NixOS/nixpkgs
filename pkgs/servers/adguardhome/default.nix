{ lib, stdenv, fetchurl, fetchzip, nixosTests }:

let
  inherit (stdenv.hostPlatform) system;
  sources = import ./bins.nix { inherit fetchurl fetchzip; };
in

stdenv.mkDerivation rec {
  pname = "adguardhome";
  version = "0.107.52";
  src = sources.${system} or (throw "Source for ${pname} is not available for ${system}");

  installPhase = ''
    install -m755 -D ./AdGuardHome $out/bin/adguardhome
  '';

  passthru = {
    updateScript = ./update.sh;
    schema_version = 28;
    tests.adguardhome = nixosTests.adguardhome;
  };

  meta = with lib; {
    homepage = "https://github.com/AdguardTeam/AdGuardHome";
    description = "Network-wide ads & trackers blocking DNS server";
    platforms = builtins.attrNames sources;
    maintainers = with maintainers; [ numkem iagoq rhoriguchi ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.gpl3Only;
    mainProgram = "adguardhome";
  };
}
