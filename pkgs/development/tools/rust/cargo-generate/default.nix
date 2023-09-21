{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libgit2_1_6
, openssl
, stdenv
, darwin
, git
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-generate";
  version = "0.18.4";

  src = fetchFromGitHub {
    owner = "cargo-generate";
    repo = "cargo-generate";
    rev = "v${version}";
    sha256 = "sha256-u4LEE3fDYneKhNU38VeVNvqcbDO0pws6yldgcvwSv6M=";
  };

  cargoSha256 = "sha256-pgffaqHWnm3RBE9TGbpRJX35BFpXW/na9wmad9eyCXw=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libgit2_1_6 openssl ] ++ lib.optionals stdenv.isDarwin [
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
    maintainers = with maintainers; [ figsoda turbomack matthiasbeyer ];
  };
}
