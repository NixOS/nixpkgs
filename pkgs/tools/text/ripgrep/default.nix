{ stdenv, fetchFromGitHub, rustPlatform, asciidoc, docbook_xsl, libxslt
, Security
, withPCRE2 ? true, pcre2 ? null
}:

rustPlatform.buildRustPackage rec {
  pname = "ripgrep";
  version = "11.0.2";

  src = fetchFromGitHub {
    owner = "BurntSushi";
    repo = pname;
    rev = version;
    sha256 = "1iga3320mgi7m853la55xip514a3chqsdi1a1rwv25lr9b1p7vd3";
  };

  cargoSha256 = "0lwz661rbm7kwkd6mallxym1pz8ynda5f03ynjfd16vrazy2dj21";

  cargoBuildFlags = stdenv.lib.optional withPCRE2 "--features pcre2";

  nativeBuildInputs = [ asciidoc docbook_xsl libxslt ];
  buildInputs = (stdenv.lib.optional withPCRE2 pcre2)
    ++ (stdenv.lib.optional stdenv.isDarwin Security);

  preFixup = ''
    mkdir -p "$out/man/man1"
    cp target/release/build/ripgrep-*/out/rg.1 "$out/man/man1/"

    mkdir -p "$out/share/"{bash-completion/completions,fish/vendor_completions.d,zsh/site-functions}
    cp target/release/build/ripgrep-*/out/rg.bash "$out/share/bash-completion/completions/"
    cp target/release/build/ripgrep-*/out/rg.fish "$out/share/fish/vendor_completions.d/"
    cp "$src/complete/_rg" "$out/share/zsh/site-functions/"
  '';

  meta = with stdenv.lib; {
    description = "A utility that combines the usability of The Silver Searcher with the raw speed of grep";
    homepage = https://github.com/BurntSushi/ripgrep;
    license = with licenses; [ unlicense /* or */ mit ];
    maintainers = with maintainers; [ tailhook globin ma27 ];
    platforms = platforms.all;
  };
}
