{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-temp";
<<<<<<< HEAD
  version = "0.2.18";

  src = fetchFromGitHub {
    owner = "yozhgoor";
    repo = "cargo-temp";
    rev = "v${version}";
    hash = "sha256-JUpXLdFaG653u9a4Nq7TC1ZNEcZ0QzgYMjGS8Kam0ec=";
  };

  cargoHash = "sha256-7yPvHCmdokb/oJqR3h+RJOQbE/pcrIDBltnG5zfoqMk=";
=======
  version = "0.2.16";

  src = fetchFromGitHub {
    owner = "yozhgoor";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-9rFczpVboJ+TPQzuegFj8RGYBel+4n5iY4B0sruK5wc=";
  };

  cargoSha256 = "sha256-uIgDs7dFJjZgOE/y3T11N3zl8AwRvIyJbIC7wD7Nr7Q=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A CLI tool that allow you to create a temporary new Rust project using cargo with already installed dependencies";
    homepage = "https://github.com/yozhgoor/cargo-temp";
<<<<<<< HEAD
    changelog = "https://github.com/yozhgoor/cargo-temp/releases/tag/${src.rev}";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
=======
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
