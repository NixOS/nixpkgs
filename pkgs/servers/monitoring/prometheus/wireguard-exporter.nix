{ stdenv, rustPlatform, fetchFromGitHub, lib, Security }:

rustPlatform.buildRustPackage rec {
  pname = "wireguard-exporter";
  version = "3.2.4";

  src = fetchFromGitHub {
    owner = "MindFlavor";
    repo = "prometheus_wireguard_exporter";
    rev = version;
    sha256 = "15his6mv3vmzfg972fb8m01h2m3jxmaqz3zw2krfr136mvg2rvjw";
  };

  cargoSha256 = "1kxzhwz7i1nlywf01zsbrv1qnssmj7dviq9nk9ywbr6xbjq8zl3h";

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "A Prometheus exporter for WireGuard, written in Rust.";
    license = licenses.mit;
    homepage = https://github.com/MindFlavor/prometheus_wireguard_exporter;
    maintainers = with maintainers; [ ma27 globin ];
  };
}
