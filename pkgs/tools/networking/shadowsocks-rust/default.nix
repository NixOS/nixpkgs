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

  cargoSha256 = "1m0p40z6qx6s0r1x6apz56n2s4ppn8b2cff476xrfhp6s1j046q7";

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
