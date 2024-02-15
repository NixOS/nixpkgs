{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "prometheus-nats-exporter";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Zg4zmb0tvu7JPv9XS5Qd5o/ClnODSPz36isjUbFM1ec=";
  };

  vendorHash = "sha256-VygRE6YviSSIYpMbTEPndR6WUmLAZDwgvuJcwBuizck=";

  preCheck = ''
    # Fix `insecure algorithm SHA1-RSA` problem
    export GODEBUG=x509sha1=1;
  '';

  meta = with lib; {
    description = "Exporter for NATS metrics";
    homepage = "https://github.com/nats-io/prometheus-nats-exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ bbigras ];
  };
}
