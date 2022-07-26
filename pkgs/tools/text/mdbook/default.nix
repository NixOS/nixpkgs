{ lib, stdenv, fetchFromGitHub, nix, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook";
  version = "0.4.20";

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "mdBook";
    rev = "v${version}";
    sha256 = "sha256-Cfi9qjY7+G7nGgxt4xNLIkGlpgr6TnvGlFrz3gMKCX8=";
  };

  cargoSha256 = "sha256-Ihs5aaruzj/8gbUhg4MmrYmpS9Hi/DohuEV2WtrxUXE=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  # Tests rely on unset 'RUST_LOG' value to emit INFO messages.
  # 'RUST_LOG=' nixpkgs default enables warnings only and breaks tests.
  # Can be removed when https://github.com/rust-lang/mdBook/pull/1777
  # is released.
  logLevel = "info";

  passthru = {
    tests = {
      inherit nix;
    };
  };

  meta = with lib; {
    description = "Create books from MarkDown";
    homepage = "https://github.com/rust-lang/mdBook";
    license = [ licenses.mpl20 ];
    maintainers = [ maintainers.havvy ];
  };
}
