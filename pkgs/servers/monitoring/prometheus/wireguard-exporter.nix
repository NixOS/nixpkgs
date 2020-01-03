{ stdenv, rustPlatform, fetchFromGitHub, lib, Security }:

rustPlatform.buildRustPackage rec {
  pname = "wireguard-exporter";
  version = "3.2.2";

  src = fetchFromGitHub {
    owner = "MindFlavor";
    repo = "prometheus_wireguard_exporter";
    rev = version;
    sha256 = "18khym7ygj29w98zf6i1l5c2pz84zla2z34l5jnh595xvwfl94pc";
  };

  cargoSha256 = "1bi9nr1dhyv322pq6fjrhs12h3wdak53mvwkbyim1hmrp62vky4m";

  buildInputs = lib.optional stdenv.isDarwin Security;

  # Commonly used hack in nixpkgs to allow unstable features on a stable rustc. This is needed
  # since `prometheus_exporter_base` uses `#!feature[]` to enable async which
  # is actually not needed as `async` is part of rustc 1.39.0-stable. This can be removed
  # as soon as https://github.com/MindFlavor/prometheus_exporter_base/pull/15 is merged.
  RUSTC_BOOTSTRAP = 1;

  meta = with lib; {
    description = "A Prometheus exporter for WireGuard, written in Rust.";
    license = licenses.mit;
    homepage = https://github.com/MindFlavor/prometheus_wireguard_exporter;
    maintainers = with maintainers; [ ma27 globin ];
  };
}
