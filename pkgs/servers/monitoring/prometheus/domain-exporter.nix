{ lib, buildGoModule, fetchFromGitHub, fetchpatch, nixosTests }:

buildGoModule rec {
  pname = "domain-exporter";
  version = "1.22.0";

  src = fetchFromGitHub {
    owner = "caarlos0";
    repo = "domain_exporter";
    rev = "v${version}";
    hash = "sha256-tdAU4BY2jT3l/VMIthrJOPhPYi9UMYD7ZUVhwbO1oUA=";
  };

  vendorHash = "sha256-6C1LfWF4tjCGW3iiEhD+qBJ+CjAv4A9KYKH/owTAYJ8=";

  doCheck = false; # needs internet connection

  passthru.tests = { inherit (nixosTests.prometheus-exporters) domain; };

  meta = with lib; {
    homepage = "https://github.com/caarlos0/domain_exporter";
    description = "Exports the expiration time of your domains as prometheus metrics";
    license = licenses.mit;
    maintainers = with maintainers; [ mmilata prusnak peterhoeg caarlos0 ];
  };
}
