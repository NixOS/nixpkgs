{ lib, stdenv, fetchurl, fetchzip, nixosTests }:

let
  inherit (stdenv.hostPlatform) system;
  sources = import ./bins.nix { inherit fetchurl fetchzip; };
in

stdenv.mkDerivation rec {
  pname = "adguardhome";
<<<<<<< HEAD
  version = "0.107.36";
=======
  version = "0.107.29";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = sources.${system} or (throw "Source for ${pname} is not available for ${system}");

  installPhase = ''
    install -m755 -D ./AdGuardHome $out/bin/adguardhome
  '';

  passthru = {
    updateScript = ./update.sh;
<<<<<<< HEAD
    schema_version = 24;
=======
    schema_version = 20;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    tests.adguardhome = nixosTests.adguardhome;
  };

  meta = with lib; {
    homepage = "https://github.com/AdguardTeam/AdGuardHome";
    description = "Network-wide ads & trackers blocking DNS server";
    platforms = builtins.attrNames sources;
    maintainers = with maintainers; [ numkem iagoq rhoriguchi ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.gpl3Only;
  };
}
