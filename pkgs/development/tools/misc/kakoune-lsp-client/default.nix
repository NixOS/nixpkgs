{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name = "kakoune-lsp-client-${version}";
  version = "5.2.1";

  src = fetchFromGitHub {
    owner = "ul";
    repo = "kak-lsp";
    rev = "v" + version;
    sha256 = "0jgdpxcjvzk6zp3kak6bhvhzmgmaga74ia1c3y2i5z39w6gjbycj";
  };

  cargoSha256 = "0pa16923n2nkxxz991dgh9ilydpi4lfb9j23aciylmss909dv29f";

  postInstall = ''
    install -Dm644 -t "$out/etc/kak-lsp" kak-lsp.toml
    install -Dm644 -t "$out/lib/systemd/user" kak-lsp.service
  '';

  meta = with stdenv.lib; {
    description = "A Language Server Protocol client for Kakoune implemented in Rust";
    homepage = https://github.com/ul/kak-lsp;
    license = with licenses; [ unlicense ];
    maintainers = with maintainers; [ nrdxp ];
    platforms = platforms.all;
  };
}
