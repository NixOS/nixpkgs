{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "complgen";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "adaszko";
    repo = "complgen";
    rev = "v${version}";
    hash = "sha256-zNYNwPPVlsvQiHy28rWB7OlnriJVktoFrDkJaIO9z8E=";
  };

  cargoHash = "sha256-BkflZ/d4TAZjjkQB5f0+rL4Zt7uWBLM3gM2UNKYZz+Q=";

  meta = with lib; {
    description = "Generate {bash,fish,zsh} completions from a single EBNF-like grammar";
    homepage = "https://github.com/adaszko/complgen";
    changelog = "https://github.com/adaszko/complgen/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
