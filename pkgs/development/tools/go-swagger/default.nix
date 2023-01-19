{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "go-swagger";
  version = "0.30.4";

  src = fetchFromGitHub {
    owner = "go-swagger";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5jnSuJqy5oaRxmZh2rr1hoBJPS4S9s0FhMZ4AY61w1I=";
  };

  vendorHash = "sha256-EVsJP04yBiquux5LRR23bGRzrLiXBO9VA8UGlZEpgi8=";

  doCheck = false;

  subPackages = [ "cmd/swagger" ];

  ldflags = [ "-s" "-w" "-X github.com/go-swagger/go-swagger/cmd/swagger/commands.Version=${version}" "-X github.com/go-swagger/go-swagger/cmd/swagger/commands.Commit=${src.rev}" ];

  meta = with lib; {
    description = "Golang implementation of Swagger 2.0, representation of your RESTful API";
    homepage = "https://github.com/go-swagger/go-swagger";
    license = licenses.asl20;
    maintainers = with maintainers; [ kalbasit ];
    mainProgram = "swagger";
  };
}
