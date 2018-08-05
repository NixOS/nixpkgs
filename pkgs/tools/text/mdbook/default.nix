{ stdenv, fetchFromGitHub, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  name = "mdbook-${version}";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "rust-lang-nursery";
    repo = "mdBook";
    rev = "v${version}";
    sha256 = "0lmklvpjvi21hcx9cnl6nizgnwflf5hs150yhckik0sp990sdvp7";
  };

  cargoSha256 = "0n7jcccp56lv5w8x25zij6big5g3z1wxgh06q7b413nnvj9wq47k";

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
