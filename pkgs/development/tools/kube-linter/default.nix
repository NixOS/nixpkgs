{ lib, buildGoModule, fetchFromGitHub, testVersion, kube-linter }:

buildGoModule rec {
  pname = "kube-linter";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "stackrox";
    repo = pname;
    rev = "${version}";
    sha256 = "GUDrUEBorV4/ZqPnfNYcsbW4Zr1LpS3yL+4OgxFbTOk=";
  };

  vendorSha256 = "xGghTP9thICOGIfc5VPJK06DeXfLiTckwa4nXv83/P8=";

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
