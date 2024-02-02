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
  version = "0.28.0";

  src = fetchFromGitHub {
    owner = "obi1kenobi";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-5QXTbsNp36jYrcSDmCXT5Nmhhr9TaWpF3QqaCKv5TTg=";
  };

  cargoHash = "sha256-uRgSNVleGzD75q16hd/AOl23DT1btWGuNgZ2IprGa7k=";

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
