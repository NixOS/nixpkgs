{ lib
, buildNpmPackage
, fetchFromGitHub
, nodejs_18
, systemdMinimal
, nixosTests
, nix-update-script
}:

buildNpmPackage rec {
  pname = "zigbee2mqtt";
  version = "1.35.3";

  src = fetchFromGitHub {
    owner = "Koenkk";
    repo = "zigbee2mqtt";
    rev = version;
    hash = "sha256-pj+8BiEcR8Z88J3xxEa4IRBlt9Lv7IoSrKAQ6Y5oydI=";
  };

  npmDepsHash = "sha256-15aZyICTRq6DvW2arKtdT+jXDyGtVD7ncer8e4d+03E=";

  nodejs = nodejs_18;

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
