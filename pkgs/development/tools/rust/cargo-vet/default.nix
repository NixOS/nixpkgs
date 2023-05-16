{ lib, rustPlatform, fetchFromGitHub, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-vet";
<<<<<<< HEAD
  version = "0.8.0";
=======
  version = "0.6.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-VnOqQ1dKgNZSHTzJrD7stoCzNGrSkYxcLDJAsrJUsEQ=";
  };

  cargoSha256 = "sha256-M8sZzgSEMIB6pPVaE+tC18MCbwYaYpHOnhrEvm9JTso=";
=======
    sha256 = "sha256-PAqpVixBdytHvSUu03OyoA1QGBxmmoeV78x6wCiCemQ=";
  };

  cargoSha256 = "sha256-dsaDpDa/BNqnL3K4a1mg3uEyM094/UO73MzJD9YaAwE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = lib.optional stdenv.isDarwin Security;

  # the test_project tests require internet access
  checkFlags = [
    "--skip=test_project"
  ];

  meta = with lib; {
    description = "A tool to help projects ensure that third-party Rust dependencies have been audited by a trusted source";
    homepage = "https://mozilla.github.io/cargo-vet";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda jk ];
  };
}
