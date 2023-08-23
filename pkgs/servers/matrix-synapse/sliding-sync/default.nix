{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "matrix-sliding-sync";
  version = "0.99.6";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "sliding-sync";
    rev = "v${version}";
    hash = "sha256-t0TlmoqXaKR5PrR0vlsLU84yBdXPXmE63n6p4sMvHhs=";
  };

  vendorHash = "sha256-9bJ6B9/jq7q5oJGULRPoNVJiqoO+2E2QQKORy4rt6Xw=";

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
