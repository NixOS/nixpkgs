{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, kbld }:

buildGoModule rec {
  pname = "kbld";
  version = "0.37.0";

  src = fetchFromGitHub {
    owner = "carvel-dev";
    repo = "kbld";
    rev = "v${version}";
    sha256 = "sha256-AQ+4eF5wdL14I2JbZrcz6okEkHtBnyczU91aM5rGvpI=";
  };

  vendorHash = null;

  subPackages = [ "cmd/kbld" ];

  ldflags = [
    "-X github.com/vmware-tanzu/carvel-kbld/pkg/kbld/version.Version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  passthru.tests.version = testers.testVersion {
    package = kbld;
  };

  meta = with lib; {
    description = "kbld seamlessly incorporates image building and image pushing into your development and deployment workflows";
    homepage = "https://carvel.dev/kbld";
    license = licenses.asl20;
    maintainers = with maintainers; [ selmison ];
  };
}
