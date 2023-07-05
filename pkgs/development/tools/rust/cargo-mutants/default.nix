{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-mutants";
  version = "23.6.0";

  src = fetchFromGitHub {
    owner = "sourcefrog";
    repo = "cargo-mutants";
    rev = "cargo-mutants-${version}";
    hash = "sha256-qgsranCZnorEZuCgUj0LmkL0dcfarWa0q/9Uupsf4jQ=";
  };

  cargoHash = "sha256-BW9itNgVOiaKMzaRl3d60BIV5V82+5D0+QKSnGcvFnI=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  # too many tests require internet access
  doCheck = false;

  meta = with lib; {
    description = "A mutation testing tool for Rust";
    homepage = "https://github.com/sourcefrog/cargo-mutants";
    changelog = "https://github.com/sourcefrog/cargo-mutants/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
