{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubepug";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "rikatz";
    repo = "kubepug";
    rev = "v${version}";
    hash = "sha256-HjnkGEzTobtILqML5xcjpYVtg6a5PqMKYyaGTYrqEDo=";
  };

  vendorHash = "sha256-w2WwJa8qaXmgFwZJo2r2TowcTehgQY0nGY4u1UROaxM=";

  ldflags = [
    "-s"
    "-w"
    "-X sigs.k8s.io/release-utils/version.gitVersion=${version}"
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
