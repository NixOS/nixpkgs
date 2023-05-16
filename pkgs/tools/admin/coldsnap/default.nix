{ lib
, rustPlatform
, fetchFromGitHub
, openssl
, stdenv
, Security
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "coldsnap";
<<<<<<< HEAD
  version = "0.6.0";
=======
  version = "0.5.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-zXLt16ffqbExU23uRI7U99nUwpSKTIf039dDq+k2KAA=";
  };
  cargoHash = "sha256-RRyAzD9eiscZ9kB5tFh5vUnGk6XYYKy0/TAjcaygmG4=";
=======
    hash = "sha256-WqNGajtezhBDYmgUayKjdNAZSyKirIYeYOnozMCIya4=";
  };
  cargoHash = "sha256-av9hsvY8xsB+HlIRLYNFDJc9eyBfOyBZ347vWoVsDmM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security ];
  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    homepage = "https://github.com/awslabs/coldsnap";
    description = "A command line interface for Amazon EBS snapshots";
    changelog = "https://github.com/awslabs/coldsnap/blob/${src.rev}/CHANGELOG.md";
<<<<<<< HEAD
    license = licenses.asl20;
=======
    license = licenses.apsl20;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = teams.determinatesystems.members;
  };
}
