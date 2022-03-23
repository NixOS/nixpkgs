{ stdenv, rustPlatform, fetchFromGitHub, lib, libiconv, Security, nixosTests }:

rustPlatform.buildRustPackage rec {
  pname = "wireguard-exporter";
  version = "3.6.2";

  src = fetchFromGitHub {
    owner = "MindFlavor";
    repo = "prometheus_wireguard_exporter";
    rev = version;
    sha256 = "sha256-eVGyBynKZLGlsaLwUOx7cJWdRHl65S0Wk1K5c9T8ysQ=";
  };

  cargoSha256 = "sha256-JbFoaMTs6TPYq2qgBkT7WX1itMXohgcWbC1UvaXOi8o=";

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security ];

  passthru.tests = { inherit (nixosTests.prometheus-exporters) wireguard; };

  meta = with lib; {
    description = "A Prometheus exporter for WireGuard, written in Rust";
    homepage = "https://github.com/MindFlavor/prometheus_wireguard_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ ma27 globin ];
  };
}
