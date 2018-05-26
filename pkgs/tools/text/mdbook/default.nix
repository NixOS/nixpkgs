{ stdenv, fetchFromGitHub, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  name = "mdbook-${version}";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "rust-lang-nursery";
    repo = "mdBook";
    rev = "ea0b835b38aba9566c1cc50ad119fbbf2c56f59d";
    sha256 = "0jkyys8dg5mchbj8b73mmzsgv0k0zp7knima9s69s5ybplmd2n8s";
  };

  cargoSha256 = "0w3slfzm29pkyr6zhr7k9rx9mddh42asyb46bzy57j0a2qvan3k4";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with stdenv.lib; {
    description = "Create books from MarkDown";
    homepage = https://github.com/rust-lang-nursery/mdbook;
    license = [ licenses.asl20 licenses.mit ];
    maintainers = [ maintainers.havvy ];
    platforms = platforms.all;

    # Because CoreServices needs to be updated,
    # but Apple won't release the source.
    broken = stdenv.isDarwin;
  };
}
