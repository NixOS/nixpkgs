{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "highlight-assertions";
  version = "unstable-2022-11-24";

  src = fetchFromGitHub {
    owner = "thehamsta";
    repo = pname;
    rev = "c738a51513285ded4fc16d68afcdb77761543f92";
    sha256 = "sha256-vYXr0xFwRUwSEP++834A/4M1QB14Wx+qWwB9PUtn3uA=";
  };

  cargoSha256 = "sha256-sezjd7tmVVDoRsrsTK2zKjHmrBcAQDHyHd/dR1q1za0=";

  # requires nightly features
  RUSTC_BOOTSTRAP = 1;

  meta = with lib; {
    description = "A tool for unit testing tree sitter highlights for nvim-treesitter";
    homepage = "https://github.com/thehamsta/highlight-assertions";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
