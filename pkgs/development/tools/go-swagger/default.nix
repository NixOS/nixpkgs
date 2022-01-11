{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "go-swagger";
  version = "0.28.0";

  src = fetchFromGitHub {
    owner = "go-swagger";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Bw84HQxrI8cSBEM1cxXmWCPqKZa5oGsob2iuUsiAZ+A=";
  };

  vendorSha256 = "sha256-ZNRJZQ7DwT/+scsbSud/IpSX06veOtJ5Aszj0RbS870=";

  doCheck = false;

  subPackages = [ "cmd/swagger" ];

  ldflags = [ "-s" "-w" "-X github.com/go-swagger/go-swagger/cmd/swagger/commands.Version=${version}" "-X github.com/go-swagger/go-swagger/cmd/swagger/commands.Commit=${src.rev}" ];

  meta = with lib; {
    description = "Golang implementation of Swagger 2.0, representation of your RESTful API";
    homepage = "https://github.com/go-swagger/go-swagger";
    license = licenses.asl20;
    maintainers = with maintainers; [ kalbasit ];
  };
}
