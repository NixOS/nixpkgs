{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper }:

with rustPlatform;

buildRustPackage rec {
  name = "ripgrep-${version}";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "BurntSushi";
    repo = "ripgrep";
    rev = "${version}";
    sha256 = "0z3f83vhy464k93bc55i9lr6z41163q96if938p9ndhx2q3a20ql";
  };

  cargoSha256 = "1d6s01gmyfzb0vdf7flq6nvlapwcgbj0mzcprzyg4nj5gjkvznrn";

  preFixup = ''
    mkdir -p "$out/man/man1"
    cp "$src/doc/rg.1" "$out/man/man1"
  '';

  meta = with stdenv.lib; {
    description = "A utility that combines the usability of The Silver Searcher with the raw speed of grep";
    homepage = https://github.com/BurntSushi/ripgrep;
    license = with licenses; [ unlicense /* or */ mit ];
    maintainers = [ maintainers.tailhook ];
    platforms = platforms.all;
  };
}
