{ lib, rustPlatform, fetchFromGitHub, openssl, pkg-config, nixosTests }:

rustPlatform.buildRustPackage rec {
  pname = "unbound-telemetry";
  version = "unstable-2021-03-17";

  src = fetchFromGitHub {
    owner = "svartalf";
    repo = pname;
    rev = "7f1b6d4e9e4b6a3216a78c23df745bcf8fc84021";
    sha256 = "xCelL6WGaTRhDJkkUdpdwj1zcKKAU2dyUv3mHeI4oAw=";
  };

  cargoSha256 = "P3nAtYOuwNSLMP7q1L5zKTsZ6rJA/qL1mhVHzP3szi4=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  passthru.tests = {
    inherit (nixosTests.prometheus-exporters) unbound;
  };

  meta = with lib; {
    description = "Prometheus exporter for Unbound DNS resolver";
    homepage = "https://github.com/svartalf/unbound-telemetry";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
