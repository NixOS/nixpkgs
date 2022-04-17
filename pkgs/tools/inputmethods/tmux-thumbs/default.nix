{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "tmux-thumbs";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "fcsonline";
    repo = pname;
    rev = version;
    sha256 = "sha256-PH1nscmVhxJFupS7dlbOb+qEwG/Pa/2P6XFIbR/cfaQ=";
  };

  cargoSha256 = "sha256-HzuNwN1KI8shDeF56qJZk6hmU2XS11x6d7YY3Q2W9c8=";

  meta = with lib; {
    description = "A lightning fast version of tmux-fingers written in Rust, copy/pasting tmux like vimium/vimperator";
    homepage = "https://github.com/fcsonline/tmux-thumbs";
    license = licenses.mit;
    maintainers = with maintainers; [ papojari ];
  };
}
