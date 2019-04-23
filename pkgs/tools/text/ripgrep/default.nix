{ stdenv, fetchFromGitHub, rustPlatform, asciidoc, docbook_xsl, libxslt
, Security
, withPCRE2 ? false, pcre2 ? null
}:

rustPlatform.buildRustPackage rec {
  pname = "ripgrep";
  version = "11.0.1";

  src = fetchFromGitHub {
    owner = "BurntSushi";
    repo = pname;
    rev = version;
    sha256 = "0vak82d4vyw0w8agswbyxa6g3zs2h9mxm2xjw0xs9qccvmi7whbb";
  };

  cargoSha256 = "0i31d0m145dsjfix589p5pfp83qp3a5wvz1v9sp4bxn3rggmw734";

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
