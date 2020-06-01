{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, openssl, libsodium, Security }:

rustPlatform.buildRustPackage rec {
  pname = "shadowsocks-rust";
  version = "1.8.11";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "shadowsocks";
    repo = pname;
    sha256 = "0imnvx3v0msk9qf72zy1qg5q52dmc8xfs9iwdwa2q13scjslgmwn";
  };

  cargoSha256 = "1aqqx0pdq3vp5c06pjwsrbrqfkz5dhxnpvv3vnr3pqfm62xrffgg";

  SODIUM_USE_PKG_CONFIG = 1;

  buildInputs = [ openssl libsodium ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ Security ];
  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/shadowsocks/shadowsocks-rust";
    description = "A Rust port of shadowsocks";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
