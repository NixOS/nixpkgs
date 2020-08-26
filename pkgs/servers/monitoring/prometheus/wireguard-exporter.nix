{ stdenv, rustPlatform, fetchFromGitHub, lib, Security, nixosTests }:

rustPlatform.buildRustPackage rec {
  pname = "wireguard-exporter";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "MindFlavor";
    repo = "prometheus_wireguard_exporter";
    rev = version;
    sha256 = "1c6zadqnn4b83yglcdn1hw54jj1c4makbdy6fli3cfb7sha1ynml";
  };

  cargoSha256 = "148982ypkxhab2kmijk9zwwi5l6nk4rcdwaz0r1j9fni47q49f35";

  buildInputs = lib.optional stdenv.isDarwin Security;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) wireguard; };

  meta = with lib; {
    description = "A Prometheus exporter for WireGuard, written in Rust.";
    homepage = "https://github.com/MindFlavor/prometheus_wireguard_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ ma27 globin ];
  };
}
