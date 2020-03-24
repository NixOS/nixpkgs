{ stdenv, fetchFromGitHub, rustPlatform, CoreServices, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "rust-lang-nursery";
    repo = "mdBook";
    rev = "v${version}";
    sha256 = "07rpak233mi6ssqbpqsccn66a32jcgl90a5iyl2l5yyxw95rcya0";
  };

  cargoSha256 = "0aanngwx7k86fb11zjx4wx954md446nn8667f2plr6bkqmlpxlkr";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with stdenv.lib; {
    description = "Create books from MarkDown";
    homepage = "https://github.com/rust-lang-nursery/mdbook";
    license = [ licenses.mpl20 ];
    maintainers = [ maintainers.havvy ];
    platforms = platforms.all;
  };
}
