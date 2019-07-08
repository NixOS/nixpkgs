{ stdenv, rustPlatform, fetchFromGitHub, lib, Security }:

rustPlatform.buildRustPackage rec {
  pname = "wireguard-exporter";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "MindFlavor";
    repo = "prometheus_wireguard_exporter";
    rev = version;
    sha256 = "11yrry8fzalcigqsx1wx371w543gdcsx48fd7dacbrsfl2dk2azp";
  };

  cargoSha256 = "1wnk39p144zjsdhnyjk6y41xs448bxnbbxkqk53r6i2f2wzrsk2m";

  buildInputs = lib.optional stdenv.isDarwin Security;

  doCheck = false;

  meta = with lib; {
    description = "A Prometheus exporter for WireGuard, written in Rust.";
    license = licenses.mit;
    homepage = https://github.com/MindFlavor/prometheus_wireguard_exporter;
    maintainers = with maintainers; [ ma27 ];
  };
}
