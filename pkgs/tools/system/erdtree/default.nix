{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "erdtree";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "solidiquis";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-iiGtpzoyA4PpS5redrwYeAQb/sJ149e1/ZJ0R1ctYFk=";
  };

  cargoHash = "sha256-TfGA6AMG9zBrossM0vsRt6OY0etfWNR1FnpgiP/mfi4=";

  meta = with lib; {
    description = "File-tree visualizer and disk usage analyzer";
    homepage = "https://github.com/solidiquis/erdtree";
    changelog = "https://github.com/solidiquis/erdtree/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda zendo ];
    mainProgram = "erd";
  };
}
