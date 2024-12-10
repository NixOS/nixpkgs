{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  systemdMinimal,
  nixosTests,
  nix-update-script,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemdMinimal,
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
    maintainers = with maintainers; [
      sweber
      hexa
    ];
    mainProgram = "zigbee2mqtt";
  };
}
