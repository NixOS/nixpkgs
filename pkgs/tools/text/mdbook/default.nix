{ lib, stdenv, fetchFromGitHub, nix, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook";
  version = "0.4.34";

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "mdBook";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-QkgsFnX6J0ZgXCzGE/dTNLxdXLhCFwLsZCvmZ4SU4Zs=";
  };

  cargoHash = "sha256-Dhblzn7NytYeY76RmvI8cNjChnCSnTPadxPKyU5QT1Q=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  passthru = {
    tests = {
      inherit nix;
    };
  };

  meta = with lib; {
    description = "Create books from MarkDown";
    homepage = "https://github.com/rust-lang/mdBook";
    changelog = "https://github.com/rust-lang/mdBook/blob/v${version}/CHANGELOG.md";
    license = [ licenses.mpl20 ];
    maintainers = with maintainers; [ havvy Frostman matthiasbeyer ];
  };
}
