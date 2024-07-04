{ lib
, stdenv
, buildNpmPackage
, fetchFromGitHub
, systemdMinimal
, nixosTests
, nix-update-script
, withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemdMinimal
}:

buildNpmPackage rec {
  pname = "zigbee2mqtt";
  version = "1.38.0";

  src = fetchFromGitHub {
    owner = "Koenkk";
    repo = "zigbee2mqtt";
    rev = version;
    hash = "sha256-h++IXL1y6f52mSBRP3TiqLMKkFXP/QKaNlpM2PCgT5k=";
  };

  npmDepsHash = "sha256-OsG9FCdlSQYWrne/jaklNIsCT0M4+vt8DxZ9CGPfbzM=";

  buildInputs = lib.optionals withSystemd [
    systemdMinimal
  ];

  npmFlags = lib.optionals (!withSystemd) [ "--omit=optional" ];

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
    mainProgram = "zigbee2mqtt";
  };
}
