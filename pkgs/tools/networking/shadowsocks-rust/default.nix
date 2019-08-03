{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, openssl, libsodium, Security }:

rustPlatform.buildRustPackage rec {
  pname = "shadowsocks-rust";
  version = "1.7.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "shadowsocks";
    repo = pname;
    sha256 = "0mqjm54mp6c9mfdl3gf01v9vm2rjll8fw63n6j4qgv01y4hrsm4f";
  };

  cargoSha256 = "19wx19sbal2q5ndniv6vllayjjy5fzi8fw7fn1d23jb9l91ak7ab";

  buildInputs = [ openssl libsodium ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ Security ];
  nativeBuildInputs = [ pkgconfig ];

  # tries to read /etc/resolv.conf, hence fails in sandbox
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/shadowsocks/shadowsocks-rust;
    description = "A Rust port of shadowsocks";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
