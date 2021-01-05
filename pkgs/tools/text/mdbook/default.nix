{ stdenv, fetchFromGitHub, rustPlatform, CoreServices, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "rust-lang-nursery";
    repo = "mdBook";
    rev = "v${version}";
    sha256 = "11v2x0q8pn7hbmznqy872ksr7szyiki9cfhapymjhkf5nwfvcdbb";
  };

  cargoSha256 = "1psgqj04hzv7p18h4phsahxg4rj9yz38b8mh111k6l8m4r83kd75";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with stdenv.lib; {
    description = "Create books from MarkDown";
    homepage = "https://github.com/rust-lang-nursery/mdbook";
    license = [ licenses.mpl20 ];
    maintainers = [ maintainers.havvy ];
  };
}
