{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "alejandra";
  version = "unstable-2022-02-12";

  src = fetchFromGitHub {
    owner = "kamadorueda";
    repo = "alejandra";
    rev = "bfda2490bcb6f7dab2d15f033f65441af283d48d";
    hash = "sha256-D7dCtwwQcrSnC7MjoqB0ogCsCmrthqy+TqbqbJUT6zE=";
  };

  cargoSha256 = "sha256-Gos0ku4wR0jP1FQLYBVMqZN4qW0Tx45qpIL99s6a+t8=";

  meta = with lib; {
    description = "The Uncompromising Nix Code Formatter";
    homepage = "https://github.com/kamadorueda/alejandra";
    license = licenses.unlicense;
    maintainers = with maintainers; [ _0x4A6F kamadorueda ];
  };
}
