{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "jotdown";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "hellux";
    repo = "jotdown";
    rev = version;
    hash = "sha256-SdMj2/r/QhmgS1T3Ve4ypQ2nDjoSRkEtWzQCcbFWP5A=";
  };

  cargoHash = "sha256-OzLPlWZwDEO8TPk79LHCRLtMFxZigaIAbLM75KDqyj4=";

  meta = with lib; {
    description = "A minimal Djot CLI";
    homepage = "https://github.com/hellux/jotdown";
    changelog = "https://github.com/hellux/jotdown/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
