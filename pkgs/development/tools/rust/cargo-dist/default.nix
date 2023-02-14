{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, bzip2
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-dist";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "axodotdev";
    repo = "cargo-dist";
    rev = "v${version}";
    hash = "sha256-7/TUk9LGwmHhKwFtwFQM7C/1ItRsoJ4IodeUPWfGjkc=";
  };

  cargoHash = "sha256-vmHPjecd1u0f8wSTu+LE2BNiZlskDADLXNjIj2v7D5E=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    bzip2
  ];

  meta = with lib; {
    description = "A tool for building final distributable artifacts and uploading them to an archive";
    homepage = "https://github.com/axodotdev/cargo-dist";
    changelog = "https://github.com/axodotdev/cargo-dist/blob/${src.rev}/RELEASES.md";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
