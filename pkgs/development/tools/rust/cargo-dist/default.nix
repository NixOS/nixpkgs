{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, bzip2
, stdenv
, rustup
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-dist";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "axodotdev";
    repo = "cargo-dist";
    rev = "v${version}";
    hash = "sha256-7JbWcG5FDJaXvtEQKlOgbsFpFQQ3n02MVFD+lCFXtt0=";
  };

  cargoHash = "sha256-TY1YRtre2rz0Hh+6ca22i+XCBMOEOS3QnSsf/rfY47g=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    bzip2
  ];

  nativeCheckInputs = lib.optionals stdenv.isDarwin [
    rustup
  ];

  meta = with lib; {
    description = "A tool for building final distributable artifacts and uploading them to an archive";
    homepage = "https://github.com/axodotdev/cargo-dist";
    changelog = "https://github.com/axodotdev/cargo-dist/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
