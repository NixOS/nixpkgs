{
  lib,
  stdenv,
  fetchurl,
  fetchzip,
  nixosTests,
}:

let
  inherit (stdenv.hostPlatform) system;
  sources = import ./bins.nix { inherit fetchurl fetchzip; };
in

stdenv.mkDerivation rec {
  pname = "adguardhome";
  version = "0.107.55";
  src = sources.${system} or (throw "Source for ${pname} is not available for ${system}");

  installPhase = ''
    install -m755 -D ./AdGuardHome $out/bin/adguardhome
  '';

  passthru = {
    updateScript = ./update.sh;
    schema_version = 29;
    tests.adguardhome = nixosTests.adguardhome;
  };

  meta = {
    homepage = "https://github.com/AdguardTeam/AdGuardHome";
    description = "Network-wide ads & trackers blocking DNS server";
    platforms = builtins.attrNames sources;
    maintainers = with lib.maintainers; [
      numkem
      iagoq
      rhoriguchi
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.gpl3Only;
    mainProgram = "adguardhome";
  };
}
