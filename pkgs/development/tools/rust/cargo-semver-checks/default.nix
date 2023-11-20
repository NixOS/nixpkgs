{ lib
, rustPlatform
, fetchFromGitHub
, cmake
, zlib
, stdenv
, darwin
, git
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-semver-checks";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "obi1kenobi";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-cy1YgNBxVSxdoVq/2t6Uf4PBQf54degabtEYfIeIBDU=";
  };

  cargoHash = "sha256-Xl6wneomb5NeqhA9pMyNkCtc6FgYtx7k2zgQ3oBHP/Q=";

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  nativeCheckInputs = [
    git
  ];

  checkFlags = [
    # requires nightly version of cargo-rustdoc
    "--skip=both_passing_manifest_path_and_directory_works"
    "--skip=verify_binary_contains_lints"

    # requires internet access
    "--skip=detects_target_dependencies"
  ];

  preCheck = ''
    patchShebangs scripts/regenerate_test_rustdocs.sh
    git init
    scripts/regenerate_test_rustdocs.sh
  '';

  meta = with lib; {
    description = "A tool to scan your Rust crate for semver violations";
    homepage = "https://github.com/obi1kenobi/cargo-semver-checks";
    changelog = "https://github.com/obi1kenobi/cargo-semver-checks/releases/tag/v${version}";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
  };
}
