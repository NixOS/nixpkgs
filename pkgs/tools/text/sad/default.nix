{ lib
, fetchFromGitHub
, rustPlatform
, python3
}:

rustPlatform.buildRustPackage rec {
  pname = "sad";
  version = "0.4.27";

  src = fetchFromGitHub {
    owner = "ms-jpq";
    repo = "sad";
    rev = "refs/tags/v${version}";
    hash = "sha256-hb09YwF59I8zQ6dIrGkCWJ98VeB5EYoNloTGg5v2BIs=";
  };

  cargoHash = "sha256-wFmC19uGEaS8Rn+bKdljAZY24/AL9VDV183xXBjt79M=";

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
