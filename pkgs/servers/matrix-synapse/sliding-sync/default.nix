{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "matrix-sliding-sync";
  version = "0.99.7";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "sliding-sync";
    rev = "v${version}";
    hash = "sha256-LSxh7dvw4B0hVcIzbknIpXGOWZYEs+cjO9w4xJxkZps=";
  };

  vendorHash = "sha256-JYSpjAgIvQFpYmOTifRXHVB6bSrukqSVhmAAmHylPbQ=";

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
