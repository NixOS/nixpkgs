{ stdenv, fetchFromGitHub, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  name = "mdbook-${version}";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "rust-lang-nursery";
    repo = "mdBook";
    rev = "v${version}";
    sha256 = "0m0vprjpd02z4nr3vd4qha2jka7l36k4liw8jcbf4xs09c584sjv";
  };

  cargoSha256 = "19hpr78p9rzgirq6fjw8v11d5mgcglms6vbqgjyvg49xmkklsqzr";
  depsSha256 = "0q68qyl2h6i0qsz82z840myxlnjay8p1w5z7hfyr8fqp7wgwa9cx";

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
