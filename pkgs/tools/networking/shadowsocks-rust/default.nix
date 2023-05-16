{ lib, stdenv, fetchFromGitHub, rustPlatform, pkg-config, openssl, Security, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "shadowsocks-rust";
<<<<<<< HEAD
  version = "1.16.1";
=======
  version = "1.15.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "shadowsocks";
    repo = pname;
<<<<<<< HEAD
    hash = "sha256-h/2zHxgp8sXcUOpmtneoAX0hNt19pObfyGW3wIzQNxc=";
  };

  cargoHash = "sha256-MZGd1SyTSZ6y9W9h+M3Y5cwX6hLCFiuPZb307PRtvQk=";
=======
    hash = "sha256-HU+9y4btWbYrkHazOudY2j9RceieBK3BS2jgLbwcEdk=";
  };

  cargoHash = "sha256-YORQHX4RPPHDErgo4c3SxvxklJ9mxHeP/1GiwhuL+J0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
    "--skip=tcprelay"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    "--skip=udp_tunnel"
    "--skip=udp_relay"
    "--skip=socks4_relay_connect"
    "--skip=socks5_relay_aead"
    "--skip=socks5_relay_stream"
<<<<<<< HEAD
    "--skip=trust_dns_resolver"
  ];

  # timeouts in sandbox
  doCheck = false;

=======
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "A Rust port of Shadowsocks";
    homepage = "https://github.com/shadowsocks/shadowsocks-rust";
    changelog = "https://github.com/shadowsocks/shadowsocks-rust/raw/v${version}/debian/changelog";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
