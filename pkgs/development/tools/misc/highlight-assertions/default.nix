{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "highlight-assertions";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "thehamsta";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-OVf8s7zuGj5//zWJIVBfHBoA6zD+l8lqVQGn2vHsvSQ=";
  };

  cargoSha256 = "sha256-cS4IbFuxZCKDIAcgiKzBF/qQ6mXZb9omvMeGcU+yWpk=";

  # requires nightly features
  RUSTC_BOOTSTRAP = 1;

  meta = with lib; {
    description = "A tool for unit testing tree sitter highlights for nvim-treesitter";
    homepage = "https://github.com/thehamsta/highlight-assertions";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
