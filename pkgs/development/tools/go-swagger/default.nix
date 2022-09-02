{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "go-swagger";
  version = "0.30.0";

  src = fetchFromGitHub {
    owner = "go-swagger";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Hc3b1r8Wr8cXAWoqINneBRU1Mdv4RkAeOOCK7O9Vp9g=";
  };

  vendorSha256 = "sha256-g/0OjAqT+0P0VtB0i0o2QfMqU8YDnoRtwA5isNJlSBE=";

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
