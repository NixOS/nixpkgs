{ lib, stdenv, fetchFromGitHub, rustPlatform, pkg-config, openssl, CoreServices, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "shadowsocks-rust";
  version = "1.14.3";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "shadowsocks";
    repo = pname;
    sha256 = "sha256-tRiziyCw1Qpm22RtZHeKt4VFReJidFHsPxPSjxIA3hA=";
  };

  cargoSha256 = "sha256-snnzNb1yJ8L5pMvNNEIf5hZOpFV6DKOWGtGP1T3YTWg=";

  RUSTC_BOOTSTRAP = 1;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ CoreServices libiconv ];

  cargoBuildFlags = [
    "--features=aead-cipher-extra,local-dns,local-http-native-tls,local-redir,local-tun"
  ];

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
