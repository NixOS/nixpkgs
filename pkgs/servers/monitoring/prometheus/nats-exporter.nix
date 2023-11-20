{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "prometheus-nats-exporter";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-TsFj/iUG/PkGvVVn5RSWwEnHsEIGWMY8iapBHVpzt1c=";
  };

  vendorHash = "sha256-IoguUXHxEeyHb2io41ROgam8+7vD5WKzEWwNh4Dlk1o=";

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
