{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "go-swagger";
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "go-swagger";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-mBBjZRjaD1m6sIKR1/MRAKW25bGVNihxBwQMbw/lby4=";
  };

  vendorSha256 = "sha256-Am0ypcViUcAcf96qv5qE7K3FvQuQs1XlpIqZf2upWyc=";

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
