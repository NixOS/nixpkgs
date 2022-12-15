{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libgit2
, openssl
, stdenv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-generate";
  version = "0.17.4";

  src = fetchFromGitHub {
    owner = "cargo-generate";
    repo = "cargo-generate";
    rev = "v${version}";
    sha256 = "sha256-3dJ16G1PCLAV1sxtDt+eru+Chg7SWt+K/crJgXMO++k=";
  };

  # patch Cargo.toml to not vendor libgit2 and openssl
  cargoPatches = [ ./no-vendor.patch ];

  cargoSha256 = "sha256-eLPLBBytzjKfJk0pbPBC0kJrxkelfDrAj5kaM6g9z9w=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libgit2 openssl ]
    ++ lib.optionals stdenv.isDarwin [ Security ];

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
    maintainers = with maintainers; [ figsoda turbomack ];
  };
}
