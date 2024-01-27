{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "trippy";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "fujiapple852";
    repo = "trippy";
    rev = version;
    hash = "sha256-Q5WPpCm1RNLlNX8G1U160O2wJz+y+KMScApjx6gIBCg=";
  };

  cargoHash = "sha256-brvfAZZ3L0loZQowcRfkS7o7ZYQB9hr5o1rgMSWaljU=";

  meta = with lib; {
    description = "A network diagnostic tool";
    homepage = "https://trippy.cli.rs";
    changelog = "https://github.com/fujiapple852/trippy/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "trip";
  };
}
