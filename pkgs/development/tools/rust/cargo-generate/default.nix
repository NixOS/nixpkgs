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
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "cargo-generate";
    repo = "cargo-generate";
    rev = "v${version}";
    sha256 = "sha256-qL5ZbLimpsi/7yuhubHF3/tAouE/5zCWRx4nZG841cU=";
  };

  # patch Cargo.toml to not vendor libgit2 and openssl
  cargoPatches = [ ./no-vendor.patch ];

  cargoSha256 = "sha256-OB3rjJNxkUKRQPsWRvCniNPfYBgLFV4yXO7dnVvL7wo=";

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
      "--skip favorites::favorites_default_to_git_if_not_defined"
      # Probably git 2.38.1 releated failure
      # Upstream issue https://github.com/cargo-generate/cargo-generate/issues/777
      "--skip basics::it_loads_a_submodule"
    ] ++ lib.optionals stdenv.isDarwin [ "--skip git::utils::should_canonicalize" ];

  meta = with lib; {
    description = "cargo, make me a project";
    homepage = "https://github.com/cargo-generate/cargo-generate";
    changelog = "https://github.com/cargo-generate/cargo-generate/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda turbomack ];
  };
}
