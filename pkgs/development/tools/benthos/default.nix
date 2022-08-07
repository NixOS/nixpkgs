{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "benthos";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "benthosdev";
    repo = "benthos";
    rev = "v${version}";
    sha256 = "sha256-tRB9eTeyEyPkiR/sph76CMbPjJUNoDzfYuHmtFAzY7E=";
  };

  vendorSha256 = "sha256-nnaBQ7ADdAdo/+RQzXJHBBpXgTmxny0O/ij+eWsS5YM=";

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
