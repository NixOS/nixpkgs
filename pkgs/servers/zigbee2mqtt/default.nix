{ lib
, buildNpmPackage
, fetchFromGitHub
, systemdMinimal
, nixosTests
, nix-update-script
}:

buildNpmPackage rec {
  pname = "zigbee2mqtt";
  version = "1.37.1";

  src = fetchFromGitHub {
    owner = "Koenkk";
    repo = "zigbee2mqtt";
    rev = version;
    hash = "sha256-rpFx3OveHhurwb08jl0WHf121v0L/r0FQCIpHRJ1V24=";
  };

  npmDepsHash = "sha256-AjCeRU/Ew9UquqGPuJeGRC48kCi9uRZaI5Bam365Wwk=";

  buildInputs = [
    systemdMinimal
  ];

  passthru.tests.zigbee2mqtt = nixosTests.zigbee2mqtt;
  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    changelog = "https://github.com/Koenkk/zigbee2mqtt/releases/tag/${version}";
    description = "Zigbee to MQTT bridge using zigbee-shepherd";
    homepage = "https://github.com/Koenkk/zigbee2mqtt";
    license = licenses.gpl3;
    longDescription = ''
      Allows you to use your Zigbee devices without the vendor's bridge or gateway.

      It bridges events and allows you to control your Zigbee devices via MQTT.
      In this way you can integrate your Zigbee devices with whatever smart home infrastructure you are using.
    '';
    maintainers = with maintainers; [ sweber hexa ];
    platforms = platforms.linux;
    mainProgram = "zigbee2mqtt";
  };
}
