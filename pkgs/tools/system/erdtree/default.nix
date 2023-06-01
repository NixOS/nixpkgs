{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "erdtree";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "solidiquis";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-vaxfW5LuXN/Q8cjJY2V0xTahEtZKYJf+8y2z9Df4WFs=";
  };

  cargoHash = "sha256-BB25p9Zy3Z7oztt/AZRNc7mmrSYfVFyUr/t5t2azoYg=";

  meta = with lib; {
    description = "File-tree visualizer and disk usage analyzer";
    homepage = "https://github.com/solidiquis/erdtree";
    changelog = "https://github.com/solidiquis/erdtree/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda zendo ];
    mainProgram = "erd";
  };
}
