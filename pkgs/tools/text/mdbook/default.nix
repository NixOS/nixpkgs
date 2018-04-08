{ stdenv, fetchFromGitHub, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  name = "mdbook-${version}";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "rust-lang-nursery";
    repo = "mdBook";
    rev = "v${version}";
    sha256 = "0k86zjrqb5wdxvmzz9cxl9c0mpjnr46fh5r5sbs5q9fk2h4lp4ip";
  };

  cargoSha256 = "0gj1x996lvn9j87dfmng2fn3fgz8rgvrw3akcz641psj4hlfgm5w";

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
