{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "erdtree";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "solidiquis";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-W9rTsumZZ3O0kOc+dT9TC/Z/Katb3q6yFreAVCvX5qo=";
  };

  cargoHash = "sha256-6jFBNkiCFBQbpiYkNZ6dyXH/ZnFHZYFliMZFlE/DodM=";

  meta = with lib; {
    description = "File-tree visualizer and disk usage analyzer";
    homepage = "https://github.com/solidiquis/erdtree";
    license = licenses.mit;
    maintainers = with maintainers; [ zendo ];
    mainProgram = "et";
  };
}
