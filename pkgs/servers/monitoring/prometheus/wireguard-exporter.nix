{ stdenv, rustPlatform, fetchFromGitHub, lib, libiconv, Security, nixosTests }:

rustPlatform.buildRustPackage rec {
  pname = "wireguard-exporter";
  version = "3.6.3";

  src = fetchFromGitHub {
    owner = "MindFlavor";
    repo = "prometheus_wireguard_exporter";
    rev = version;
    sha256 = "sha256-m29/whlmhIkLin84NOWs2NVZcXNpVsyyHZ1CLp4FXd0=";
  };

  cargoSha256 = "sha256-XK4hjBIcOx6JMv61gOpIXaZy7Unw+Bk84TEb+8Fib6Q=";

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security ];

  passthru.tests = { inherit (nixosTests.prometheus-exporters) wireguard; };

  meta = with lib; {
    description = "A Prometheus exporter for WireGuard, written in Rust";
    homepage = "https://github.com/MindFlavor/prometheus_wireguard_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ ma27 globin ];
  };
}
