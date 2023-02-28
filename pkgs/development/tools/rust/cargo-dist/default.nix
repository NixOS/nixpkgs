{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, bzip2
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-dist";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "axodotdev";
    repo = "cargo-dist";
    rev = "v${version}";
    hash = "sha256-I++dffdEXDg55WR66+Zl5P2KBvt19sp3aZkXA1GBb4A=";
  };

  cargoHash = "sha256-fLHkW28V5MBQeQDd0VrtEjou5FYwArkNDtS/jXKo8G8=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    bzip2
  ];

  meta = with lib; {
    description = "A tool for building final distributable artifacts and uploading them to an archive";
    homepage = "https://github.com/axodotdev/cargo-dist";
    changelog = "https://github.com/axodotdev/cargo-dist/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
