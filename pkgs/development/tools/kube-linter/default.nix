{ lib, buildGoModule, fetchFromGitHub, testVersion, kube-linter }:

buildGoModule rec {
  pname = "kube-linter";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "stackrox";
    repo = pname;
    rev = "${version}";
    sha256 = "nBF/AX4hgZxIj9/RYowpHX1eAJMMhvU7wunvEXWnO80=";
  };

  vendorSha256 = "HJW28BZ9qFLtdH1qdW8/K4TzHA2ptekXaMF0XnMKbOY=";

  ldflags = [
    "-s" "-w" "-X golang.stackrox.io/kube-linter/internal/version.version=${version}"
  ];

  passthru.tests.version = testVersion {
    package = kube-linter;
    command = "kube-linter version";
  };

  meta = with lib; {
    description = "A static analysis tool that checks Kubernetes YAML files and Helm charts";
    homepage = "https://kubelinter.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ mtesseract ];
  };
}
