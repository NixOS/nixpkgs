{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubepug";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "rikatz";
    repo = "kubepug";
    rev = "v${version}";
    sha256 = "sha256-ySGNEs9PwkpjcLaCZ9M6ewE0/PRdwDksJMJ2GZUUrng=";
  };

  vendorSha256 = "sha256-faco4/6ldZiD2pkvjFgWDHbpCcNA4dGXxVhuO3PK77k=";

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
