{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "matrix-sliding-sync";
  version = "0.99.4";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "sliding-sync";
    rev = "v${version}";
    hash = "sha256-s7hQ4qCOhkNS8Mc2HZjFqedtj0KqXMAxVMZRIjPyvOA=";
  };

  vendorHash = "sha256-447P2TbBUEHmHubHiiZCrFVCj2/tmEuYFzLo27UyCk4=";

  subPackages = [ "cmd/syncv3" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.GitCommit=${src.rev}"
  ];

  # requires a running matrix-synapse
  doCheck = false;

  meta = with lib; {
    description = "A sliding sync implementation of MSC3575 for matrix";
    homepage = "https://github.com/matrix-org/sliding-sync";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ emilylange ];
    mainProgram = "syncv3";
  };
}
