{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
<<<<<<< HEAD
, libgit2_1_6
=======
, libgit2
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, openssl
, stdenv
, darwin
, git
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-generate";
<<<<<<< HEAD
  version = "0.18.4";
=======
  version = "0.18.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "cargo-generate";
    repo = "cargo-generate";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-u4LEE3fDYneKhNU38VeVNvqcbDO0pws6yldgcvwSv6M=";
  };

  cargoSha256 = "sha256-pgffaqHWnm3RBE9TGbpRJX35BFpXW/na9wmad9eyCXw=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libgit2_1_6 openssl ] ++ lib.optionals stdenv.isDarwin [
=======
    sha256 = "sha256-FtYdhnw8QrW2wHjLLIXVcByiVFQ97eyrZWsaxt7mmPE=";
  };

  cargoSha256 = "sha256-UM9sf4LMR7x6haDH7/DFjsZZCng+9E5EnLt6HtTLvCU=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libgit2 openssl ] ++ lib.optionals stdenv.isDarwin [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    darwin.apple_sdk.frameworks.Security
  ];

  nativeCheckInputs = [ git ];

  # disable vendored libgit2 and openssl
  buildNoDefaultFeatures = true;

  preCheck = ''
    export HOME=$(mktemp -d) USER=nixbld
    git config --global user.name Nixbld
    git config --global user.email nixbld@localhost.localnet
  '';

  # Exclude some tests that don't work in sandbox:
  # - favorites_default_to_git_if_not_defined: requires network access to github.com
  # - should_canonicalize: the test assumes that it will be called from the /Users/<project_dir>/ folder on darwin variant.
  checkFlags = [
    "--skip=favorites::favorites_default_to_git_if_not_defined"
  ] ++ lib.optionals stdenv.isDarwin [
    "--skip=git::utils::should_canonicalize"
  ];

  meta = with lib; {
    description = "A tool to generaet a new Rust project by leveraging a pre-existing git repository as a template";
    homepage = "https://github.com/cargo-generate/cargo-generate";
    changelog = "https://github.com/cargo-generate/cargo-generate/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
<<<<<<< HEAD
    maintainers = with maintainers; [ figsoda turbomack matthiasbeyer ];
=======
    maintainers = with maintainers; [ figsoda turbomack ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
