{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "blackbox_exporter";
  version = "0.20.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "prometheus";
    repo = "blackbox_exporter";
    sha256 = "sha256-Y3HdFIChkQVooxy2I2Gbqw3WLHsI4Zm+osHTzFluRZA=";
  };

  vendorSha256 = "sha256-KFLR0In4txQQp5dt8P0yAFtf82b4SBq2xMnlz+vMuuU=";

  # dns-lookup is performed for the tests
  doCheck = false;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) blackbox; };

  meta = with lib; {
    description = "Blackbox probing of endpoints over HTTP, HTTPS, DNS, TCP and ICMP";
    homepage = "https://github.com/prometheus/blackbox_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ globin fpletz willibutz Frostman ];
    platforms = platforms.unix;
  };
}
