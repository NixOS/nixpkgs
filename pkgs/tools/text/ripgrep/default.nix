{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper }:

with rustPlatform;

buildRustPackage rec {
  name = "ripgrep-${version}";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "BurntSushi";
    repo = "ripgrep";
    rev = "${version}";
    sha256 = "13mg624867hqxp9pzpq1gn9kqkvbaqcphdjia3bz5wvff1cbxkfy";
  };

  depsSha256 = "0glw8xk77w2h1xg6c451fg8cmwx3vz7dyzdrbf0i8d84yq8sh0i1";

  preFixup = ''
    mkdir -p "$out/man/man1"
    cp "$src/doc/rg.1" "$out/man/man1"
  '';

  meta = with stdenv.lib; {
    description = "A utility that combines the usability of The Silver Searcher with the raw speed of grep";
    homepage = https://github.com/BurntSushi/ripgrep;
    license = with licenses; [ unlicense ];
    maintainers = [ maintainers.tailhook ];
    platforms = platforms.all;
  };
}
