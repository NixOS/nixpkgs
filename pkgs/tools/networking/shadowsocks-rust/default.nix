{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, openssl, libsodium, Security }:

rustPlatform.buildRustPackage rec {
  pname = "shadowsocks-rust";
  version = "1.8.17";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "shadowsocks";
    repo = pname;
    sha256 = "1fl23q4hccwdapknj7yd8294jil15758k1r6ljbms2gijlly9lg3";
  };

  cargoSha256 = "0jgzh9p6ziq3337461cj4fkbghks3bq8dnrn6ab8dkynjwvd47bx";

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
