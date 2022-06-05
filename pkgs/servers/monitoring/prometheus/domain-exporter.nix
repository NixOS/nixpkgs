{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "domain-exporter";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "caarlos0";
    repo = "domain_exporter";
    rev = "v${version}";
    sha256 = "018y0xwdn2f2shhwaa0hqm4y8xsbqwif0733qb0377wpjbj4v137";
  };

  vendorSha256 = "0s1hs8byba9y57abg386n09wfg1wcqpzs164ap0km8ap2i96bdlb";

  doCheck = false; # needs internet connection

  passthru.tests = { inherit (nixosTests.prometheus-exporters) domain; };

  meta = with lib; {
    homepage = "https://github.com/caarlos0/domain_exporter";
    description = "Exports the expiration time of your domains as prometheus metrics";
    license = licenses.mit;
    maintainers = with maintainers; [ mmilata prusnak ];
  };
}
