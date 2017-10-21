{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper }:

with rustPlatform;

buildRustPackage rec {
  name = "ripgrep-${version}";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "BurntSushi";
    repo = "ripgrep";
    rev = "${version}";
    sha256 = "1cnvwxbznmsn1gand8hhy5zadax5p67lvm46fkj1a1s89f158w3a";
  };

  cargoSha256 = "00y2vdnrg02clqin9pg57s9micrp66f6y49wq89cmykrfg3r8cwf";

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
