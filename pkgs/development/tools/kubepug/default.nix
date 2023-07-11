{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubepug";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "rikatz";
    repo = "kubepug";
    rev = "v${version}";
    hash = "sha256-/VkJSZdiU93+GnLxIPPE2ewlm52tp7Wqry0TvjyeqhI=";
  };

  vendorHash = "sha256-fPyXOMJ0rRssGzOca54A5l8ZWixOC58Xtb3SOYSibCo=";

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
