{ stdenv, fetchFromGitHub, rustPlatform, asciidoc, docbook_xsl, libxslt  }:

rustPlatform.buildRustPackage rec {
  name = "ripgrep-${version}";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "BurntSushi";
    repo = "ripgrep";
    rev = version;
    sha256 = "089xffrqi4wm0w1lhy5iqxrcb82ca44bxl8qps4ilv0ih91vxwfj";
  };

  cargoSha256 = "1wsw7s1bc1gnpq4kjzkas5zf2snhpx9f6cyrrf6g5jr8l0hcbyih";

  nativeBuildInputs = [ asciidoc docbook_xsl libxslt ];

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
