{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper }:

with rustPlatform;

buildRustPackage rec {
  name = "ripgrep-${version}";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "BurntSushi";
    repo = "ripgrep";
    rev = "${version}";
    sha256 = "0whw6hqjkf6sysrfv931jaia2hqhy8m9aa5rxax1kygm4snz4j85";
  };

  depsSha256 = "10f7pkgaxwizl7kzhkry7wx1rgm9wsybwkk92myc29s7sqir2mx4";

  meta = with stdenv.lib; {
    description = "An untility that combines the usability of The Silver Searcher with the raw speed of grep";
    homepage = https://github.com/BurntSushi/ripgrep;
    license = with licenses; [ unlicense ];
    maintainers = [ maintainers.tailhook ];
    platforms = platforms.all;
  };
}
