{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, openssl, libsodium, Security }:

rustPlatform.buildRustPackage rec {
  pname = "shadowsocks-rust";
  version = "1.8.16";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "shadowsocks";
    repo = pname;
    sha256 = "09wncvy1cn8038xf8srz8y955xw9h59zh7avrh060wm50azrhlg5";
  };

  cargoSha256 = "0n03dg1rrhlryap0dqqmmzhp49lxvhh3478z123x23fm04ygln44";

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
