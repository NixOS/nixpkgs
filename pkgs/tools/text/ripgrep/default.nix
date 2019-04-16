{ stdenv, fetchFromGitHub, rustPlatform, asciidoc, docbook_xsl, libxslt
, Security
, withPCRE2 ? false, pcre2 ? null
}:

rustPlatform.buildRustPackage rec {
  name = "ripgrep-${version}";
  version = "11.0.0";

  src = fetchFromGitHub {
    owner = "BurntSushi";
    repo = "ripgrep";
    rev = version;
    sha256 = "13yavwi2b4w1p5fmpfn1vnwarsanlib1vj4pn1z2hg3a3v0c10iv";
  };

  cargoSha256 = "0zrn4qshk24wzhhx7s36m27q5430gq22vnksd8kw11s3058s6pwg";

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
    maintainers = [ maintainers.tailhook ];
    platforms = platforms.all;
  };
}
