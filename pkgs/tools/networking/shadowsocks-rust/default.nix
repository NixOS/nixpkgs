{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, openssl, libsodium, Security }:

rustPlatform.buildRustPackage rec {
  pname = "shadowsocks-rust";
  version = "1.7.2";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "shadowsocks";
    repo = pname;
    sha256 = "0w7ysha46ml3j1i1knvll4pmqg291z8a2ypcy650m61dhrvkh2ng";
  };

  # Delete this on next update; see #79975 for details
  legacyCargoFetcher = true;

  cargoSha256 = "18nlvqa9ha4vs9xb60hivhgcsqr69zsigfmqyig48slvwgqkbwda";

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
