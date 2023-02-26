{ lib, buildGoModule, fetchFromGitHub, testers, cli53 }:

buildGoModule rec {
  pname = "cli53";
  version = "0.8.21";

  src = fetchFromGitHub {
    owner = "barnybug";
    repo = "cli53";
    rev = version;
    sha256 = "sha256-N7FZfc3kxbMY2ooj+ztlj6xILF3gzT60Yb/puWg58V4=";
  };

  vendorHash = "sha256-LKJXoXZS866UfJ+Edwf6AkAZmTV2Q1OI1mZfbsxHb3s=";

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
