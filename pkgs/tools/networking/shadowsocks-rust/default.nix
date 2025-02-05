{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "shadowsocks-rust";
  version = "1.22.0";

  src = fetchFromGitHub {
    owner = "shadowsocks";
    repo = "shadowsocks-rust";
    tag = "v${version}";
    hash = "sha256-rufOrNwUp8h0LoBKPyDV63WAYTLJbctWrq5Ghj6ODB4=";
  };

  useFetchCargoVendor = true;

  cargoHash = "sha256-hdHCpER4qs8W6rMmwys2KhaGDiTWcnntAL3ZeTBgt84=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ openssl ];

  buildFeatures = [
    "trust-dns"
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

  meta = {
    description = "Rust port of Shadowsocks";
    homepage = "https://github.com/shadowsocks/shadowsocks-rust";
    changelog = "https://github.com/shadowsocks/shadowsocks-rust/raw/v${version}/debian/changelog";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
