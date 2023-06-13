{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "fritzbox-exporter";
  version = "unstable-2021-04-13";

  src = fetchFromGitHub {
    rev = "fd36539bd7db191b3734e17934b5f1e78e4e9829";
    owner = "mxschmitt";
    repo = "fritzbox_exporter";
    sha256 = "0w9gdcnfc61q6mzm95i7kphsf1rngn8rb6kz1b6knrh5d8w61p1n";
  };

  subPackages = [ "cmd/exporter" ];

  vendorSha256 = "0k6bd052pjfg5c1ba1yhni8msv3wl512vfzy2hrk49jibh8h052n";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) fritzbox; };

  meta = with lib; {
    description = "Prometheus Exporter for FRITZ!Box (TR64 and UPnP)";
    homepage = "https://github.com/mxschmitt/fritzbox_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ bachp flokli sbruder ];
  };
}
