{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "matrix-sliding-sync";
  version = "0.99.19";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "sliding-sync";
    rev = "refs/tags/v${version}";
    hash = "sha256-w4VL+MioNeJ/R48Ln9tYaqlfg7NvT3mQs0dWOZTHQK4=";
  };

  vendorHash = "sha256-THjvc0TepIBFOTte7t63Dmadf3HMuZ9m0YzQMI5e5Pw=";

  subPackages = [ "cmd/syncv3" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.GitCommit=${src.rev}"
  ];

  # requires a running matrix-synapse
  doCheck = false;

  meta = with lib; {
    description = "Sliding sync implementation of MSC3575 for matrix";
    homepage = "https://github.com/matrix-org/sliding-sync";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [
      emilylange
      yayayayaka
    ];
    mainProgram = "syncv3";
  };
}
