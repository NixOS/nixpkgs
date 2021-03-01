{ stdenv, rustPlatform, fetchFromGitHub, lib, Security, nixosTests }:

rustPlatform.buildRustPackage rec {
  pname = "wireguard-exporter";
  version = "3.4.2";

  src = fetchFromGitHub {
    owner = "MindFlavor";
    repo = "prometheus_wireguard_exporter";
    rev = version;
    sha256 = "sha256-nzY+pCkj0/m7cWPq5+xvQ1b1/PqdI6QuxNdTRT030tY=";
  };

  cargoSha256 = "sha256-L2ohowt5+F3XJSzoihtJ2prW2bzZiNMUL9vqHIZBy1M=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) wireguard; };

  meta = with lib; {
    description = "A Prometheus exporter for WireGuard, written in Rust";
    homepage = "https://github.com/MindFlavor/prometheus_wireguard_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ ma27 globin ];
  };
}
