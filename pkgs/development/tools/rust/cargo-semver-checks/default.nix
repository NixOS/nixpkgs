{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
<<<<<<< HEAD
, libgit2_1_6
=======
, libgit2
, openssl
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, zlib
, stdenv
, darwin
, git
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-semver-checks";
<<<<<<< HEAD
  version = "0.23.0";
=======
  version = "0.20.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "obi1kenobi";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-/yMZ7ZmvCPFkrnuobbNGmgGNw16J8yT0DEUza7PD/Ow=";
  };

  cargoHash = "sha256-u8hja6+T3NwcNub181TfuhI9+QFuIrgqIBlb1lm8+yk=";
=======
    sha256 = "sha256-z7mDGWU498KU6lEHqLhl0HdTA55Wz3RbZOlF6g1gwN4=";
  };

  cargoSha256 = "sha256-JQdL4D6ECH8wLOCcAGm7HomJAfJD838KfI4/IRAeqD0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
<<<<<<< HEAD
    libgit2_1_6
=======
    libgit2
    openssl
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  nativeCheckInputs = [
    git
  ];

  checkFlags = [
    # requires nightly version of cargo-rustdoc
    "--skip=both_passing_manifest_path_and_directory_works"
<<<<<<< HEAD
=======
    "--skip=rustdoc_cmd::tests"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    "--skip=verify_binary_contains_lints"

    # requires internet access
    "--skip=detects_target_dependencies"
  ];

  preCheck = ''
    patchShebangs scripts/regenerate_test_rustdocs.sh
    git init
    scripts/regenerate_test_rustdocs.sh
  '';

<<<<<<< HEAD
=======
  # use system openssl
  OPENSSL_NO_VENDOR = true;

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "A tool to scan your Rust crate for semver violations";
    homepage = "https://github.com/obi1kenobi/cargo-semver-checks";
    changelog = "https://github.com/obi1kenobi/cargo-semver-checks/releases/tag/v${version}";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
  };
}
