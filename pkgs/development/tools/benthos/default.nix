{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "benthos";
  version = "4.7.0";

  src = fetchFromGitHub {
    owner = "benthosdev";
    repo = "benthos";
    rev = "v${version}";
    sha256 = "sha256-aj4MkVj1+9IcyiPWOilrk/x5Rwtoq9wwP4oCtgeb+vU=";
  };

  vendorSha256 = "sha256-aQ3z8KBTLHNs5y+8I02AIZc7p5fr10GA99YdizwSJko=";

  doCheck = false;

  subPackages = [
    "cmd/benthos"
  ];

  ldflags = [ "-s" "-w" "-X github.com/benthosdev/benthos/v4/internal/cli.Version=${version}" ];

  meta = with lib; {
    description = "Fancy stream processing made operationally mundane";
    homepage = "https://www.benthos.dev";
    license = licenses.mit;
    maintainers = with maintainers; [ sagikazarmark ];
  };
}
