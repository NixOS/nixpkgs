{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "benthos";
  version = "4.8.0";

  src = fetchFromGitHub {
    owner = "benthosdev";
    repo = "benthos";
    rev = "v${version}";
    sha256 = "sha256-jddPUNl+W8BYpBlz3h/bsz7xFvE8tSlaagBmUbOGfFI=";
  };

  vendorSha256 = "sha256-xnrw/rXOGlZduCG/Sy4GxGJaojtve+oe2zVf3sV3lJ4=";

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
