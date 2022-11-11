{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "prometheus-nats-exporter";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qUnlPGniqStU5jVg+5SR8aYO7BLo7+d+UWPPm13ov0I=";
  };

  vendorSha256 = "sha256-hlC/s0pYhNHMv3i7Nmu4r6jnXGpc6raScv5dO32+tfQ=";

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
