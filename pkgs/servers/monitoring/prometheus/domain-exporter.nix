{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "domain-exporter";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "caarlos0";
    repo = "domain_exporter";
    rev = "v${version}";
    sha256 = "0pvz5vx9jvxdrkmzqzh7dfi09sb55j6zpx5728m5v38p8cl8vyh6";
  };

  vendorSha256 = "02m2mnx93xq6cl54waazgxq6vqbswfn9aafz0h694n6rskvdn784";

  doCheck = false; # needs internet connection

  passthru.tests = { inherit (nixosTests.prometheus-exporters) domain; };

  meta = with lib; {
    homepage = "https://github.com/caarlos0/domain_exporter";
    description = "Exports the expiration time of your domains as prometheus metrics";
    license = licenses.mit;
    maintainers = with maintainers; [ mmilata prusnak ];
  };
}
