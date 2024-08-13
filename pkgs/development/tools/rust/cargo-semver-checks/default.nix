{ lib
, rustPlatform
, fetchFromGitHub
, cmake
, zlib
, stdenv
, darwin
, git
}:

rustPlatform.buildRustPackage {
  pname = "cargo-semver-checks";
  version = "0.33.0-unstable-2024-08-04";

  src = fetchFromGitHub {
    owner = "obi1kenobi";
    repo = "cargo-semver-checks";
    rev = "0d956d3dba2dffb5615d9333834cbcc21e8943c9";
    hash = "sha256-7r4QFfIUvQe9EHlr5pfoXguxcf6uJA+6NXqHvFpM47w=";
  };

  cargoHash = "sha256-aViLwSvTQZ2WFg7VX4nCV1q4vlGKVwCVzQeoDap1SAE=";

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
    description = "Tool to scan your Rust crate for semver violations";
    mainProgram = "cargo-semver-checks";
    homepage = "https://github.com/obi1kenobi/cargo-semver-checks";
    changelog = "https://github.com/obi1kenobi/cargo-semver-checks/releases/tag/v0.33.0";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
  };
}
