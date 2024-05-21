{
  lib,
  fetchFromGitHub,
  rustPlatform,
  python3,
}:

rustPlatform.buildRustPackage rec {
  pname = "sad";
  version = "0.4.28";

  src = fetchFromGitHub {
    owner = "ms-jpq";
    repo = "sad";
    rev = "refs/tags/v${version}";
    hash = "sha256-9zsNYUYUQ3RmJQN7uf+YQjywr7rRAIx5zz6EYkbN8/o=";
  };

  cargoHash = "sha256-OSVG1sFSLKkVsgI0I2mYTszcPGlfOL1Md/aCpMf6Eow=";

  nativeBuildInputs = [ python3 ];

  # fix for compilation on aarch64
  # see https://github.com/NixOS/nixpkgs/issues/145726
  prePatch = ''
    rm .cargo/config.toml
  '';

  meta = with lib; {
    description = "CLI tool to search and replace";
    homepage = "https://github.com/ms-jpq/sad";
    changelog = "https://github.com/ms-jpq/sad/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "sad";
  };
}
