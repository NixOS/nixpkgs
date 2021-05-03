{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "go-swagger";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "go-swagger";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-S3/sXmgogxhMv53Gd/ir6ScirYQtt5kn04ZfRiS6NoA=";
  };

  vendorSha256 = "sha256-ABGjrMZdgsAaEhJlGbvbX77t7TsodraadNyItESMbEc=";

  doCheck = false;

  subPackages = [ "cmd/swagger" ];

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/go-swagger/go-swagger/cmd/swagger/commands.Version=${version} -X github.com/go-swagger/go-swagger/cmd/swagger/commands.Commit=${src.rev}" ];

  meta = with lib; {
    description = "Golang implementation of Swagger 2.0, representation of your RESTful API";
    homepage = "https://github.com/go-swagger/go-swagger";
    license = licenses.asl20;
    maintainers = with maintainers; [ kalbasit ];
  };
}
