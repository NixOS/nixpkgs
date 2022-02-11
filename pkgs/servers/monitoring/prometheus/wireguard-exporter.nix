{ stdenv, rustPlatform, fetchFromGitHub, lib, libiconv, Security, nixosTests }:

rustPlatform.buildRustPackage rec {
  pname = "wireguard-exporter";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "MindFlavor";
    repo = "prometheus_wireguard_exporter";
    rev = version;
    sha256 = "sha256-LHhqQ0p2qt6ZAdkpY1SEAcGXH47TPhHvlDv+eL8GC58=";
  };

  cargoSha256 = "sha256-lNFsO7FSmH1+DLM7ID0vn6234qTdtUoaLSnqKcbHoXE=";

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security ];

  passthru.tests = { inherit (nixosTests.prometheus-exporters) wireguard; };

  meta = with lib; {
    description = "A Prometheus exporter for WireGuard, written in Rust";
    homepage = "https://github.com/MindFlavor/prometheus_wireguard_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ ma27 globin ];
  };
}
