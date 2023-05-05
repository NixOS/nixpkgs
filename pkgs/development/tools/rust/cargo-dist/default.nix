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
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "axodotdev";
    repo = "cargo-dist";
    rev = "v${version}";
    hash = "sha256-fpOBSMVBkuFJcog5g5qFO/0GI78GkkwWQC7zocrVJ2w=";
  };

  cargoHash = "sha256-BqbF21OotztNZsol6wlTDzfz0ViybPF5KK/v+F9N5Us=";

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
