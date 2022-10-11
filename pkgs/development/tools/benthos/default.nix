{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "benthos";
  version = "4.9.0";

  src = fetchFromGitHub {
    owner = "benthosdev";
    repo = "benthos";
    rev = "v${version}";
    sha256 = "sha256-gFtlu+Jg5XC9OlUArTCHPFN4iTF7kdyrcRcymRwSHsw=";
  };

  vendorSha256 = "sha256-sRhiTati1EsU+gBv29OkBAxqot+Bjp1BemYR1qbqN1w=";

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
