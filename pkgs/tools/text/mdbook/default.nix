{ stdenv, fetchFromGitHub, rustPlatform, CoreServices, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook";
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "rust-lang-nursery";
    repo = "mdBook";
    rev = "v${version}";
    sha256 = "0a5i842aqa5xaii5lfrnks0ldavbhbd3bl4f2d442i1ahbin5b32";
  };

  cargoSha256 = "1qx3447y684b7y18lgk9cc37if2ld42jnmy1kak191q6rjh5ssh7";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with stdenv.lib; {
    description = "Create books from MarkDown";
    homepage = "https://github.com/rust-lang-nursery/mdbook";
    license = [ licenses.mpl20 ];
    maintainers = [ maintainers.havvy ];
    platforms = platforms.all;
  };
}
