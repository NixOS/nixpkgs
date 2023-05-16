{ lib
, buildNpmPackage
, fetchFromGitHub
, python3
, nixosTests
, nix-update-script
}:

buildNpmPackage rec {
  pname = "zigbee2mqtt";
<<<<<<< HEAD
  version = "1.33.0";
=======
  version = "1.30.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Koenkk";
    repo = "zigbee2mqtt";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-DdRcDSvgFf+NSDpWT4MnAOLNJ5sfqvJqKBhfPwTHd/g=";
  };

  npmDepsHash = "sha256-ov1ftDqJtxLCu3xgtGcg+Q2OMkOsHrwk1SNNfdlUieY=";
=======
    hash = "sha256-jS5O52frZY+OVLtMZkjZQskKuHs5T8zKTwjGKh77EAo=";
  };

  npmDepsHash = "sha256-71BbMBt0vXsuL8senZ7IvT3Y3OtvewQtWk1bzKUBtjI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    python3
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
  };
}
