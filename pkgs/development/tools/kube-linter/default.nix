{ lib, buildGoModule, fetchFromGitHub, testers, kube-linter }:

buildGoModule rec {
  pname = "kube-linter";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "stackrox";
    repo = pname;
    rev = version;
    sha256 = "ZqnD9zsh+r1RL34o1nAkvO1saKe721ZJ2+DgBjmsH58=";
  };

  vendorSha256 = "sha256-tm1+2jsktNrw8S7peJz7w8k3+JwAYUgKfKWuQ8zIfvk=";

  ldflags = [
    "-s" "-w" "-X golang.stackrox.io/kube-linter/internal/version.version=${version}"
  ];

  passthru.tests.version = testers.testVersion {
    package = kube-linter;
    command = "kube-linter version";
  };

  meta = with lib; {
    description = "A static analysis tool that checks Kubernetes YAML files and Helm charts";
    homepage = "https://kubelinter.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ mtesseract stehessel ];
  };
}
