{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "thumbs";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "fcsonline";
    repo = "tmux-thumbs";
    rev = version;
    sha256 = "sha256-PH1nscmVhxJFupS7dlbOb+qEwG/Pa/2P6XFIbR/cfaQ=";
  };

  cargoSha256 = "sha256-6htKiXMMyYRFefJzvDnmdx3CJ3XL8zONhGlV2wcbr9g=";

  patches = [ ./fix.patch ];

  meta = with lib; {
    homepage = "https://github.com/fcsonline/tmux-thumbs";
    description = "A lightning fast version copy/pasting like vimium/vimperator";
    license = licenses.mit;
    maintainers = with maintainers; [ ghostbuster91 ];
  };
}
