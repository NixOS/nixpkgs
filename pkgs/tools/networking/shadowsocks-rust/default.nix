{ lib, stdenv, fetchFromGitHub, rustPlatform, pkg-config, openssl, CoreServices, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "shadowsocks-rust";
  version = "1.13.5";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "shadowsocks";
    repo = pname;
    sha256 = "sha256-0TKAchPDjB7YKJO2JqBwJPZITWXDQbjPbRN8amilJ6E=";
  };

  cargoSha256 = "sha256-LBLUNBXsaGfviUUleoYIFf/vrbejKYwB9Lqetx3Agxc=";

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
