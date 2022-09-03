{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "go-swagger";
  version = "0.30.2";

  src = fetchFromGitHub {
    owner = "go-swagger";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-RV+oXcu74lyc3v3i3aQvKqrm6KrKwvPwED4JAwXgjqw=";
  };

  vendorSha256 = "sha256-F20/EQjlrwYzejLPcnuzb7K9RmbbrqU+MwzBO1MvhL4=";

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
