{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "trippy";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "fujiapple852";
    repo = "trippy";
    rev = version;
    hash = "sha256-2bh4wNP8sQcojjjbx5DQctlkwCTYcPdSkpW4OCOyp9k=";
  };

  cargoHash = "sha256-C8SUceX9RwUyiCknmuRfBqG0vjesS54bZQHwi7krwKo=";

  meta = with lib; {
    description = "A network diagnostic tool";
    homepage = "https://trippy.cli.rs";
    changelog = "https://github.com/fujiapple852/trippy/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "trip";
  };
}
