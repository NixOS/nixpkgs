{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubepug";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "rikatz";
    repo = "kubepug";
    rev = "v${version}";
    sha256 = "sha256-cjL718xTgtYev/lYL24vwZcB+joY3wIY4ixRCwAHQ4E=";
  };

  vendorSha256 = "0hynxj3q4aa1gx3w4ak56z6j5iplxi2hzqzsjkgz20fy34nfd41s";

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
