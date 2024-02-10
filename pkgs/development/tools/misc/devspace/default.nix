{ lib
, buildGoModule
, fetchFromGitHub
, testers
, devspace
}:

buildGoModule rec {
  pname = "devspace";
  version = "6.3.10";

  src = fetchFromGitHub {
    owner = "devspace-sh";
    repo = "devspace";
    rev = "v${version}";
    hash = "sha256-ExVetF5YP9gf5ifBsdPow7KA867+4iOxe/0OwZwctoc=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  # Check are disable since they requiered a working K8S cluster
  # TODO: add a nixosTest to be able to perform the package check
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = devspace;
  };

  meta = with lib; {
    description = "An open-source developer tool for Kubernetes that lets you develop and deploy cloud-native software faster";
    homepage = "https://devspace.sh/";
    changelog = "https://github.com/devspace-sh/devspace/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ darkonion0 ];
  };
}
