{ lib, buildGoModule, fetchFromGitHub, openssl }:

buildGoModule rec {
  pname = "prometheus-nats-exporter";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-siucc55qi1SS2R07xgxh25CWYjxncUqvzxo0XoIPyOo=";
  };

  vendorHash = "sha256-vRUPLKxwVTt3t8UpsSH4yMCIShpYhYI6j7AEmlyOADs=";

  ldflags = [ "-X main.version=${version}" ];

  depsBuildBuild = [ openssl ];

  preCheck = ''
    # Fix `insecure algorithm SHA1-RSA` problem
    export GODEBUG=x509sha1=1;
    # Test certs checked in to src github have a short expiry; about
    # a month. Regenerate the certs (with the provided script) so we
    # can still run the checkPhase.
    (
        set -euo pipefail -x
        cd ./test/certs
        rm -f -- ca.pem client.key client.pem server.key server.pem
        bash -euo pipefail -x ./generate-certs.sh
    )
  '';

  meta = with lib; {
    description = "Exporter for NATS metrics";
    homepage = "https://github.com/nats-io/prometheus-nats-exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ bbigras ];
  };
}
