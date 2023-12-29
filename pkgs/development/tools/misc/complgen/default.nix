{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "complgen";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "adaszko";
    repo = "complgen";
    rev = "v${version}";
    hash = "sha256-B7ydYz9nui3B/IC3obVTiJZvzTD/lCQyf+tREwFJERg=";
  };

  cargoHash = "sha256-CXvaGrE4sQlc7K6FVQqGU8EKPfHr8EIV5YFq+VMoBWg=";

  meta = with lib; {
    description = "Generate {bash,fish,zsh} completions from a single EBNF-like grammar";
    homepage = "https://github.com/adaszko/complgen";
    changelog = "https://github.com/adaszko/complgen/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
