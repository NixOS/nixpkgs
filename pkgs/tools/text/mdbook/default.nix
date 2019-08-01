{ stdenv, fetchFromGitHub, rustPlatform, CoreServices, darwin }:

rustPlatform.buildRustPackage rec {
  name = "mdbook-${version}";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "rust-lang-nursery";
    repo = "mdBook";
    rev = "v${version}";
    sha256 = "1xmw4v19ff6mvimwk5l437wslzw5npy60zdb8r4319bjf32pw9pn";
  };

  cargoSha256 = "1xpsc4qff2lrq15mz1gvmw6n5vl88sfwpjbsnp5ja5k1im156lam";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with stdenv.lib; {
    description = "Create books from MarkDown";
    homepage = https://github.com/rust-lang-nursery/mdbook;
    license = [ licenses.asl20 licenses.mit ];
    maintainers = [ maintainers.havvy ];
    platforms = platforms.all;
  };
}
