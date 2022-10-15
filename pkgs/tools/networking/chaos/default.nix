{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "chaos";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "chaos-client";
    rev = "v${version}";
    sha256 = "sha256-1bmKIBbsZHNzwFZ0iPshXclCTcQMzU7zRs5MjMhTFYU=";
  };

  vendorSha256 = "sha256-2QOdqX4JX9A/i1+qqemVq47PQfqDnxkj0EQMzK8k8/E=";

  subPackages = [
    "cmd/chaos/"
  ];

  meta = with lib; {
    description = "Tool to communicate with Chaos DNS API";
    homepage = "https://github.com/projectdiscovery/chaos-client";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
