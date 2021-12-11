{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "shadowsocks-rust";
  version = "1.12.4";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "shadowsocks";
    repo = pname;
    sha256 = "sha256-gPeikQ6a7GFgjGIwcufMCnGgqqVzHkMbQIgIPpBuOLE=";
  };

  cargoSha256 = "sha256-8qt8uapiFMhmPnbihqWoBalGV6LLsgg0pfxzw+gi4TI=";

  RUSTC_BOOTSTRAP = 1;

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices libiconv ];

  # all of these rely on connecting to www.example.com:80
  checkFlags = [
    "--skip=http_proxy"
    "--skip=tcp_tunnel"
    "--skip=udp_tunnel"
    "--skip=udp_relay"
    "--skip=socks4_relay_connect"
    "--skip=socks5_relay_aead"
    "--skip=socks5_relay_stream"
  ];

  meta = with lib; {
    homepage = "https://github.com/shadowsocks/shadowsocks-rust";
    description = "A Rust port of shadowsocks";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
