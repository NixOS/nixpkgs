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

  cargoSha256 = "0kcc0b2644qbalz7dnqwxsjdmw1h57k0rjrvwqh8apj2sgl64gyv";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [
    CoreServices
    # This is needed to avoid an undefined symbol error for "_CFURLResourceIsReachable"
    darwin.cf-private
  ];

  meta = with stdenv.lib; {
    description = "Create books from MarkDown";
    homepage = https://github.com/rust-lang-nursery/mdbook;
    license = [ licenses.asl20 licenses.mit ];
    maintainers = [ maintainers.havvy ];
    platforms = platforms.all;
  };
}
