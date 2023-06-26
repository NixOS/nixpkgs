{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "erdtree";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "solidiquis";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-fxGAvWECTQZXHIZRiMY9NGBwzsKdjbIGrzYQfj+vzww=";
  };

  cargoHash = "sha256-zdSLiTmuOnomJe9hkV9qeud7SSjJZAI7SfW9acQaH+Q=";

  meta = with lib; {
    description = "File-tree visualizer and disk usage analyzer";
    homepage = "https://github.com/solidiquis/erdtree";
    changelog = "https://github.com/solidiquis/erdtree/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda zendo ];
    mainProgram = "erd";
  };
}
