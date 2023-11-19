{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "matrix-sliding-sync";
  version = "0.99.12";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "sliding-sync";
    rev = "refs/tags/v${version}";
    hash = "sha256-7M+Ti1SfurRngXg2oCdLveG6QyjM2BjKnoovJxz7ZOY=";
  };

  vendorHash = "sha256-li5kEF7U7KyyMLMhVBqvnLuLXI6QrJl1KeusKrQXo8w=";

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
    maintainers = with maintainers; [ emilylange yayayayaka ];
    mainProgram = "syncv3";
  };
}
