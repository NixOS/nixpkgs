{ stdenv, rustPlatform, fetchFromGitHub, lib, Security }:

rustPlatform.buildRustPackage rec {
  pname = "wireguard-exporter";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "MindFlavor";
    repo = "prometheus_wireguard_exporter";
    rev = version;
    sha256 = "1vgwsg81xcxh7pcdc667mfviwwpzsm4lpllykf78vfahi9qmwffn";
  };

  cargoSha256 = "06s9194lvwd7lynxnsrjfbjfj87ngvjbqjhx3idf7d1w9mgi4ysw";

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "A Prometheus exporter for WireGuard, written in Rust.";
    license = licenses.mit;
    homepage = https://github.com/MindFlavor/prometheus_wireguard_exporter;
    maintainers = with maintainers; [ ma27 ];
  };
}
