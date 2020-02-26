{ stdenv, fetchFromGitHub, rustPlatform, CoreServices, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "rust-lang-nursery";
    repo = "mdBook";
    rev = "v${version}";
    sha256 = "0gcrv54iswphzxxkmak1c7pmmpakiri6jk50j4bxrsplwjr76f7n";
  };

  cargoSha256 = "12i9w9dgji36yvvdks0vkjjkh32nbnhz76sgrl2827pj49h9vnn0";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with stdenv.lib; {
    description = "Create books from MarkDown";
    homepage = https://github.com/rust-lang-nursery/mdbook;
    license = [ licenses.mpl20 ];
    maintainers = [ maintainers.havvy ];
    platforms = platforms.all;
  };
}
