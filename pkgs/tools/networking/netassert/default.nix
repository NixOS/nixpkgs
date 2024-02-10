{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "netassert";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "controlplaneio";
    repo = "netassert";
    rev = "v${version}";
    hash = "sha256-mRKjo0AfnM+XTl7sQoGDyQoquXpD3xPJ6i3/3Dj2rhE=";
  };
  vendorHash = "sha256-9mvSfAd1m95eRwljGG68+tjiFObgt1EuakjwFfn9Obo=";

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
