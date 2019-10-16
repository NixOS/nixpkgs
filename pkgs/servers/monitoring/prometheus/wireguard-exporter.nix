{ stdenv, rustPlatform, fetchFromGitHub, lib, Security }:

rustPlatform.buildRustPackage rec {
  pname = "wireguard-exporter";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "MindFlavor";
    repo = "prometheus_wireguard_exporter";
    rev = version;
    sha256 = "0j6xcdbh6fl8z9zyl3rqnnxjkg30nigs9a6ndlbi2ycgmlnds55m";
  };

  cargoSha256 = "1ndb33bi08j40b4jkj4q7d3k0cw5fscz2gc2cc3134nbs2r7jamk";

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "A Prometheus exporter for WireGuard, written in Rust.";
    license = licenses.mit;
    homepage = https://github.com/MindFlavor/prometheus_wireguard_exporter;
    maintainers = with maintainers; [ ma27 globin ];
  };
}
