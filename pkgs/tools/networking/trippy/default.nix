{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "trippy";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "fujiapple852";
    repo = "trippy";
    rev = version;
    hash = "sha256-IKGtnWRjrVof+2cq41TPfjhFrkn10yhY6j63dYwTzPA=";
  };

  cargoHash = "sha256-OCbrg1uSot0uNFx7uSlN5Bh6bl34ng9xO6lo9wks6nY=";

  meta = with lib; {
    description = "A network diagnostic tool";
    homepage = "https://trippy.cli.rs";
    changelog = "https://github.com/fujiapple852/trippy/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "trip";
  };
}
