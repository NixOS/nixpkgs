{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "devspace";
  version = "6.3.3";

  src = fetchFromGitHub {
    owner = "loft-sh";
    repo = "devspace";
    rev = "v${version}";
    sha256 = "sha256-xAK06bpl8BGsVUu6O1C2l+tzeiCQoRUMIUtwntUZVvU=";
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

  meta = with lib; {
    description = "DevSpace is an open-source developer tool for Kubernetes that lets you develop and deploy cloud-native software faster";
    homepage = "https://devspace.sh/";
    changelog = "https://github.com/loft-sh/devspace/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ darkonion0 ];
  };
}
