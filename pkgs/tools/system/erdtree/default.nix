{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "erdtree";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "solidiquis";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-kSJIZfL25qH+DKFG8/udv6lZt+9pBqIQvbsmT2oa3Bw=";
  };

  cargoHash = "sha256-hqS48CYlScvJiT276cAZHiilxz/Gu95WThfSj8aj0BQ=";

  meta = with lib; {
    description = "File-tree visualizer and disk usage analyzer";
    homepage = "https://github.com/solidiquis/erdtree";
    changelog = "https://github.com/solidiquis/erdtree/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda zendo ];
    mainProgram = "et";
  };
}
