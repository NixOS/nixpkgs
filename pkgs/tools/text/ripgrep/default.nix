{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper, asciidocFull }:

with rustPlatform;

buildRustPackage rec {
  name = "ripgrep-${version}";
  version = "0.8.0";

  buildInputs = [
    asciidocFull # needed for manpage generation (see build.rs)
  ];

  src = fetchFromGitHub {
    owner = "BurntSushi";
    repo = "ripgrep";
    rev = "${version}";
    sha256 = "0ha46vhma2diqxfgasdc9gwlkcrlhc4l65nayvdy4m2ah5bm4qp6";
  };

  cargoSha256 = "0q44qa9myrzg42q0lvclpk5nypmf0q7v3xy5nnsb28j3imvcrs4p";

  postInstall = ''
    mkdir -p "$out/man/man1"
    find target/release -name 'rg.1' -exec cp "{}" $out/man/man1 \;
  '';

  meta = with stdenv.lib; {
    description = "A utility that combines the usability of The Silver Searcher with the raw speed of grep";
    homepage = https://github.com/BurntSushi/ripgrep;
    license = with licenses; [ unlicense /* or */ mit ];
    maintainers = [ maintainers.tailhook ];
    platforms = platforms.all;
  };
}
