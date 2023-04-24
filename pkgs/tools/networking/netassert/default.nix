{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "netassert";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "controlplaneio";
    repo = "netassert";
    rev = "v${version}";
    hash = "sha256-bKfqSyG6YXrkHqja8f9R+49mdwOKM5NJuRrcKj7QDj8=";
  };
  vendorHash = "sha256-nDnSJOfEn9KieDwdNeIGFcI4m8rVU+Yaxwa+dKyNSHM=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${src.rev}"
  ];

  postBuild = ''
    mv $GOPATH/bin/{cli,netassert}
  '';

  meta = with lib; {
    homepage = "https://github.com/controlplaneio/netassert";
    changelog = "https://github.com/controlplaneio/netassert/blob/${src.rev}/CHANGELOG.md";
    description = "A command line utility to test network connectivity between kubernetes objects";
    longDescription = ''
      NetAssert is a command line utility to test network connectivity between kubernetes objects.
      It currently supports Deployment, Pod, Statefulset and Daemonset.
      You can check the traffic flow between these objects or from these objects to a remote host or an IP address.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ jk ];
  };
}
