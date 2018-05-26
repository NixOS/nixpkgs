{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper, asciidoc, docbook_xsl, libxslt  }:

rustPlatform.buildRustPackage rec {
  name = "ripgrep-${version}";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "BurntSushi";
    repo = "ripgrep";
    rev = "${version}";
    sha256 = "1h7k9ik723qzplwl0a5i0anzdr115wwklfgp0n11p4k2ckh7nygn";
  };

  cargoSha256 = "1gld93dxfm4vyiz1b43smbdhxmyzdk2236ksp8vw1zb1yyzn83nf";

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
