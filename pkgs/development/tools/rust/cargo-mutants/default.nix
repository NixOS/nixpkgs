{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-mutants";
  version = "24.9.0";

  src = fetchFromGitHub {
    owner = "sourcefrog";
    repo = "cargo-mutants";
    rev = "v${version}";
    hash = "sha256-fMw3Whyl+zTPpDTdYpwvzMQtSdr42ueEvkdmRI0N2aA=";
  };

  cargoHash = "sha256-+vI/HPw0oe9K0kWpJXGBM0r7oVBh3+RJzSwklaywa54=";

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
