{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "complgen";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "adaszko";
    repo = "complgen";
    rev = "v${version}";
    hash = "sha256-vMmqWN6aRw5cU3/U/ttjcPZwEk/LI6Sodf1MymgWHSE=";
  };

  cargoHash = "sha256-BhBgnDR6/El0HLgWiyUDm6xsTqAPrmNM0/6WWxcUQGI=";

  meta = with lib; {
    description = "Generate {bash,fish,zsh} completions from a single EBNF-like grammar";
    homepage = "https://github.com/adaszko/complgen";
    changelog = "https://github.com/adaszko/complgen/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
