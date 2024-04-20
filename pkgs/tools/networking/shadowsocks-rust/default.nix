{ lib, stdenv, fetchFromGitHub, rustPlatform, pkg-config, openssl, Security, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "shadowsocks-rust";
  version = "1.18.2";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "shadowsocks";
    repo = pname;
    hash = "sha256-wbbh4IpAla3I/xgmiuzy9E9npS/PUtRFCZS4dl7JYRQ=";
  };

  cargoHash = "sha256-TPW+dic9KdtGXGlcEi7YAmt442ZJRifumnrmcX8+unM=";

  nativeBuildInputs = lib.optionals stdenv.isLinux [ pkg-config ];

  buildInputs = lib.optionals stdenv.isLinux [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ Security CoreServices ];

  buildFeatures = [
    "trust-dns"
    "local-http-native-tls"
    "local-tunnel"
    "local-socks4"
    "local-redir"
    "local-dns"
    "local-tun"
    "aead-cipher-extra"
    "aead-cipher-2022"
    "aead-cipher-2022-extra"
  ];

  # all of these rely on connecting to www.example.com:80
  checkFlags = [
    "--skip=http_proxy"
    "--skip=tcp_tunnel"
    "--skip=tcprelay"
    "--skip=udp_tunnel"
    "--skip=udp_relay"
    "--skip=socks4_relay_connect"
    "--skip=socks5_relay_aead"
    "--skip=socks5_relay_stream"
    "--skip=trust_dns_resolver"
  ];

  # timeouts in sandbox
  doCheck = false;

  meta = with lib; {
    description = "A Rust port of Shadowsocks";
    homepage = "https://github.com/shadowsocks/shadowsocks-rust";
    changelog = "https://github.com/shadowsocks/shadowsocks-rust/raw/v${version}/debian/changelog";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
