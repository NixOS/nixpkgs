{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubepug";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "rikatz";
    repo = "kubepug";
    rev = "v${version}";
    sha256 = "sha256-BljDmyueGtQztdHnix4YP+zvhor1+ofahQ8971/o1xY=";
  };

  vendorSha256 = "sha256-SZckJDFYGsjYEzpJOZ1BE0gNLqn4so23OcOUnPo6zdU=";

  ldflags = [
    "-s" "-w" "-X=github.com/rikatz/kubepug/version.Version=${src.rev}"
  ];

  patches = [
    ./skip-external-network-tests.patch
  ];

  meta = with lib; {
    description = "Checks a Kubernetes cluster for objects using deprecated API versions";
    homepage = "https://github.com/rikatz/kubepug";
    license = licenses.asl20;
    maintainers = with maintainers; [ mausch ];
  };
}
