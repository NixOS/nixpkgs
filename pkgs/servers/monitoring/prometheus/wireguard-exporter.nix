{ stdenv, rustPlatform, fetchFromGitHub, lib, Security }:

rustPlatform.buildRustPackage rec {
  pname = "wireguard-exporter";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "MindFlavor";
    repo = "prometheus_wireguard_exporter";
    rev = version;
    sha256 = "0wfv54ny557mjajjdf0lyq5sbf9m7y50ggm7s2v30c639i0swyrc";
  };

  cargoSha256 = "06s9194lvwd7lynxnsrjfbjfj87ngvjbqjhx3idf7d1w9mgi4ysw";

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "A Prometheus exporter for WireGuard, written in Rust.";
    license = licenses.mit;
    homepage = https://github.com/MindFlavor/prometheus_wireguard_exporter;
    maintainers = with maintainers; [ ma27 globin ];
  };
}
