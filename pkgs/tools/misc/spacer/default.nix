{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "spacer";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "samwho";
    repo = "spacer";
    rev = "v${version}";
    hash = "sha256-KSR3KfZcPHrjKxHtgNhGS3ISR8bn8tXw9ED7OevTOsU=";
  };

  cargoHash = "sha256-Rjmy6l35pnaZTJmacoNRYvFLCRHkkJYZXLU9MVkVTfY=";

  meta = with lib; {
    description = "CLI tool to insert spacers when command output stops";
    homepage = "https://github.com/samwho/spacer";
    changelog = "https://github.com/samwho/spacer/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
