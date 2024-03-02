{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "go-swagger";
  version = "0.30.5";

  src = fetchFromGitHub {
    owner = "go-swagger";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-38Ytv/mQVi0xTydFTPNizJIjYPL+lOws6jHsRjxSC4o=";
  };

  vendorHash = "sha256-TqoTzxPGF0BBUfLtYWkljRcmr08m4zo5iroWMklxL7U=";

  doCheck = false;

  subPackages = [ "cmd/swagger" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/go-swagger/go-swagger/cmd/swagger/commands.Version=${version}"
    "-X github.com/go-swagger/go-swagger/cmd/swagger/commands.Commit=${src.rev}"
  ];

  meta = with lib; {
    description = "Golang implementation of Swagger 2.0, representation of your RESTful API";
    homepage = "https://github.com/go-swagger/go-swagger";
    changelog = "https://github.com/go-swagger/go-swagger/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ kalbasit ];
    mainProgram = "swagger";
  };
}
