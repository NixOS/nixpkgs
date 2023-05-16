{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "mqttui";
<<<<<<< HEAD
  version = "0.19.0";
=======
  version = "0.18.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "EdJoPaTo";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-cezG9hdHOeTExX4OJwJ22e/PvfdySPzQGwxumavV++Q=";
  };

  cargoHash = "sha256-vSlziZtjyzsd346qUBEPEl8I3UlPhWHRu4+FiD1XqOo=";
=======
    rev = "v${version}";
    sha256 = "sha256-XREY86CcxH+YqzOpu5vXiP6lIZaj+twKQgGmn7MR1As=";
  };

  cargoSha256 = "sha256-V5jVgNIV+Bl1nYKy2RYFbKYo/x65gG3RmB+XjFATxN8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "Terminal client for MQTT";
    homepage = "https://github.com/EdJoPaTo/mqttui";
<<<<<<< HEAD
    changelog = "https://github.com/EdJoPaTo/mqttui/blob/v${version}/CHANGELOG.md";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
