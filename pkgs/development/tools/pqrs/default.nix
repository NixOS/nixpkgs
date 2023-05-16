{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "pqrs";
<<<<<<< HEAD
  version = "0.3.1";
=======
  version = "0.2.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "manojkarthick";
    repo = "pqrs";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-t6Y6gpMEpccCoyhG66FZEKHVNCbHblaqYZY1iJUZVUA=";
  };

  cargoHash = "sha256-fnoYVWpBn5Dil2o+u2MKQqd8dEKFE2i29Qz7cJae+gE=";
=======
    sha256 = "sha256-fqxPQUcd8DG+UYJRWLDJ9RpRkCWutEXjc6J+w1qv8PQ=";
  };

  cargoSha256 = "sha256-/nfVu8eiQ8JAAUplSyA4eCQqZPCSrcxFzdc2gV95a2w=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "CLI tool to inspect Parquet files";
    homepage = "https://github.com/manojkarthick/pqrs";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = [ maintainers.manojkarthick ];
  };
}
