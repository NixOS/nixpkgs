{ stdenv, fetchFromGitHub, rustPlatform, CoreServices, darwin }:

rustPlatform.buildRustPackage rec {
  name = "mdbook-${version}";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "rust-lang-nursery";
    repo = "mdBook";
    rev = "v${version}";
    sha256 = "0py69267jbs6b7zw191hcs011cm1v58jz8mglqx3ajkffdfl3ghw";
  };

  cargoSha256 = "0qwhc42a86jpvjcaysmfcw8kmwa150lmz01flmlg74g6qnimff5m";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with stdenv.lib; {
    description = "Create books from MarkDown";
    homepage = https://github.com/rust-lang-nursery/mdbook;
    license = [ licenses.mpl20 ];
    maintainers = [ maintainers.havvy ];
    platforms = platforms.all;
  };
}
