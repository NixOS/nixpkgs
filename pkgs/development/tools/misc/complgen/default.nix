{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "complgen";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "adaszko";
    repo = "complgen";
    rev = "v${version}";
    hash = "sha256-x6r6sLdPIpf1mLRu8gT94fGoaCtnjpUIlEbMt6uSBR8=";
  };

  cargoHash = "sha256-jljrT8OymXx8OKxWU3rE52Nw5Fw9XFmgXaOMxdzMTe4=";

  meta = with lib; {
    description = "Generate {bash,fish,zsh} completions from a single EBNF-like grammar";
    homepage = "https://github.com/adaszko/complgen";
    changelog = "https://github.com/adaszko/complgen/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
