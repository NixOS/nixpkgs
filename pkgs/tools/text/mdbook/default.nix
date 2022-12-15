{ lib, stdenv, fetchFromGitHub, nix, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook";
  version = "0.4.24";

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "mdBook";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-Y7ZbgRX0ZaYtLA20fD/L9eNMbARI1f7g6O4Yl/UDO5E=";
  };

  cargoSha256 = "sha256-74LyxlDx9tVjw0KGPml6EZbAIbDiW3tvM/CEj5BW7pI=";

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
    maintainers = with maintainers; [ havvy Frostman ];
  };
}
