{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook";
  version = "0.4.17";

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "mdBook";
    rev = "v${version}";
    sha256 = "sha256-08ccRiOBXYqueKfyi/Ry39O2xOXUKishgqhn6RdbvUE=";
  };

  cargoSha256 = "sha256-vXUjKpCGlHlBvXLtmGkFtHRxxZakiEzuNzReFGEl6dw=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  # Tests rely on unset 'RUST_LOG' value to emit INFO messages.
  # 'RUST_LOG=' nixpkgs default enables warnings only and breaks tests.
  # Can be removed when https://github.com/rust-lang/mdBook/pull/1777
  # is released.
  logLevel = "info";

  meta = with lib; {
    description = "Create books from MarkDown";
    homepage = "https://github.com/rust-lang/mdBook";
    license = [ licenses.mpl20 ];
    maintainers = [ maintainers.havvy ];
  };
}
