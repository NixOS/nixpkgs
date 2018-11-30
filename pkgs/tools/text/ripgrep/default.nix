{ stdenv, fetchFromGitHub, rustPlatform, asciidoc, docbook_xsl, libxslt
, Security
, withPCRE2 ? false, pcre2 ? null
}:

rustPlatform.buildRustPackage rec {
  name = "ripgrep-${version}";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "BurntSushi";
    repo = "ripgrep";
    rev = version;
    sha256 = "017fz5kv1kv9jz7mb7vcxrklf5vybvfz2x61g6myzshqz4z1v1yb";
  };

  cargoSha256 = "0k2b2vbklfdjk2zdc8ip480drc12gy1whlwj94p44hr3402azcgr";

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
