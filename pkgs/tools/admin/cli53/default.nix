{ lib, buildGoModule, fetchFromGitHub, testers, cli53 }:

buildGoModule rec {
  pname = "cli53";
  version = "0.8.18";

  src = fetchFromGitHub {
    owner = "barnybug";
    repo = "cli53";
    rev = version;
    sha256 = "sha256-RgU4+/FQEqNpVxBktZUwoVD9ilLrTm5ZT7D8jbt2sRM=";
  };

  vendorSha256 = "sha256-uqBa2YrQwXdTemP9yB2otkSFWJqDxw/NAvIvlEbhk90=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/barnybug/cli53.version=${version}"
  ];

  passthru.tests.version = testers.testVersion {
    package = cli53;
  };

  meta = with lib; {
    description = "CLI tool for the Amazon Route 53 DNS service";
    homepage = "https://github.com/barnybug/cli53";
    license = licenses.mit;
    maintainers = with maintainers; [ benley ];
  };
}
