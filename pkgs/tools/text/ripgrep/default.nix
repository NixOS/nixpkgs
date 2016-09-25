{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper }:

with rustPlatform;

buildRustPackage rec {
  name = "ripgrep-${version}";
  version = "0.1.17";

  src = fetchFromGitHub {
    owner = "BurntSushi";
    repo = "ripgrep";
    rev = "${version}";
    sha256 = "18bpb1jl9fnipgp9icf1wwzm7934lk0ycbpvzlhvs2873zqhv6a6";
  };

  depsSha256 = "0fzjk5qynxivxmmz7r1za7mzdbdwzwwvxlc5a6cmxmzwnix2lby3";

  meta = with stdenv.lib; {
    description = "An untility that combines the usability of The Silver Searcher with the raw speed of grep";
    homepage = https://github.com/BurntSushi/ripgrep;
    license = with licenses; [ unlicense ];
    maintainers = [ maintainers.tailhook ];
    platforms = platforms.all;
  };
}
