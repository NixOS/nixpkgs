{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-mutants";
  version = "24.7.1";

  src = fetchFromGitHub {
    owner = "sourcefrog";
    repo = "cargo-mutants";
    rev = "v${version}";
    hash = "sha256-56IIMifv5epThXeWtQbNLwee1IQ52SPKik4hsHlnv6w=";
  };

  cargoHash = "sha256-VRkhDgKunSUOz2/U4oC2t0YrDh5l48z4luevMazfj6o=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  # too many tests require internet access
  doCheck = false;

  meta = with lib; {
    description = "Mutation testing tool for Rust";
    mainProgram = "cargo-mutants";
    homepage = "https://github.com/sourcefrog/cargo-mutants";
    changelog = "https://github.com/sourcefrog/cargo-mutants/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
