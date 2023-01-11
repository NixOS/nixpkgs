{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "benthos";
  version = "4.11.0";

  src = fetchFromGitHub {
    owner = "benthosdev";
    repo = "benthos";
    rev = "v${version}";
    sha256 = "sha256-1pzyrXJgVN8kO3BHr/7LMpDvtnLcdioaxoRgKv/46v4=";
  };

  vendorSha256 = "sha256-SfgdSPJ8Blra+KVWtKSjWfXmAm02tULwuYHNPbyJVpI=";

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
