{ lib, rustPlatform, fetchFromGitHub, pkg-config, openssl, stdenv, CoreServices
, Security }:

rustPlatform.buildRustPackage rec {
  pname = "railway";
<<<<<<< HEAD
  version = "3.4.0";
=======
  version = "3.3.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = "cli";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-pydnIUqUBMLHonEGcvB+K+48QQYQuFfZxbAETJjU+3o=";
  };

  cargoHash = "sha256-VgLQfUk1xeAwr9KUo1Vz4Ndw0FAnYGw3af0v3ueNPuA=";
=======
    hash = "sha256-RxZa1NH3DpHmrGbNlm85Dv1dydCC344D3lgN0lGVFt8=";
  };

  cargoHash = "sha256-3ZP4D2cEYzqrupYtKANRaMNNIZ83fTDoUedKCruk6CY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ CoreServices Security ];

  OPENSSL_NO_VENDOR = 1;

  meta = with lib; {
    mainProgram = "railway";
    description = "Railway.app CLI";
    homepage = "https://github.com/railwayapp/cli";
    changelog = "https://github.com/railwayapp/cli/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ Crafter techknowlogick ];
  };
}
