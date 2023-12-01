{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "lndmon";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "lndmon";
    rev = "v${version}";
    hash = "sha256-j9T60J7n9sya9/nN0Y6wsPDXN2h35pXxMdadsOkAMWI=";
  };

  vendorHash = "sha256-h9+/BOy1KFiqUUV35M548fDKFC3Q5mBaANuD7t1rpp8=";

  # Irrelevant tools dependencies.
  excludedPackages = [ "./tools" ];

  passthru.tests = { inherit (nixosTests.prometheus-exporters) lnd; };

  meta = with lib; {
    homepage = "https://github.com/lightninglabs/lndmon";
    description = "Prometheus exporter for lnd (Lightning Network Daemon)";
    license = licenses.mit;
    maintainers = with maintainers; [ mmilata ];
  };
}
