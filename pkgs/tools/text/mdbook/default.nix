{ lib, stdenv, fetchFromGitHub, nix, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook";
  version = "0.4.35";

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "mdBook";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-oplR34M2PbcIwrfIkA4Ttk2zt3ve883TfXGIDnfJt/4=";
  };

  cargoHash = "sha256-D0XhrweO0A1+81Je4JZ0lmnbIHstNvefpmogCyB4FEE=";

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
