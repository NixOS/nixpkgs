# references: 
# - https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=kak-lsp-git
{ stdenv, fetchFromGitHub, rustPlatform, }:
rustPlatform.buildRustPackage rec {
  name = "kak-lsp-${version}";
  version = "6.0.1";

  src = fetchFromGitHub {
    owner = "ul";
    repo = "kak-lsp";
    rev = "v${version}";
    sha256 = "0jn5ajs4sfa47gy585l8rj9yfy3qvxkzrbjb737gwc4ac4l1v9zn";
  };

  cargoSha256 = "19mmfylskkb06mzvnz97wrhh8ni8knawyl0m47fysd661fhsr7r0";

  preFixup = ''
    mkdir -p "$out/share/kak-lsp/examples"
    cp kak-lsp.toml "$out/share/kak-lsp/examples/"
  '';

  meta = with stdenv.lib; {
    description = "Kakoune Language Server Protocol Client";
    homepage = https://github.com/ul/kak-lsp;
    license = with licenses; [ unlicense ];
    maintainers = [ maintainers.swdunlop ];
    platforms = platforms.all;
  };
}
