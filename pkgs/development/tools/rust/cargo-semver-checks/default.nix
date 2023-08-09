{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libgit2
, openssl
, zlib
, stdenv
, darwin
, git
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-semver-checks";
  version = "0.22.1";

  src = fetchFromGitHub {
    owner = "obi1kenobi";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Qb01NLWCD7nglceJdUTnlf/XtPHl1P6ukr+QsjxMMos=";
  };

  cargoHash = "sha256-Qe/AGLoaCpbo001JkCN5qFytL4vWIPWhy3/pfBRoMmo=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libgit2
    openssl
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  nativeCheckInputs = [
    git
  ];

  # use system openssl
  buildNoDefaultFeatures = true;

  checkFlags = [
    # requires nightly version of cargo-rustdoc
    "--skip=both_passing_manifest_path_and_directory_works"
    "--skip=rustdoc_cmd::tests"
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
