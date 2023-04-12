{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "erdtree";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "solidiquis";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-RKIQM5RJygVL15Q3B30DXnqTSbVPJZdb8YNitanzOEA=";
  };

  cargoHash = "sha256-5bK+gJRBX0Xij5TUGD6BVWDDUJzUzHNPWoLwSXLF9iY=";

  meta = with lib; {
    description = "File-tree visualizer and disk usage analyzer";
    homepage = "https://github.com/solidiquis/erdtree";
    changelog = "https://github.com/solidiquis/erdtree/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda zendo ];
    mainProgram = "et";
  };
}
