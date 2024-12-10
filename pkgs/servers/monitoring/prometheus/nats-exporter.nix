{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

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
