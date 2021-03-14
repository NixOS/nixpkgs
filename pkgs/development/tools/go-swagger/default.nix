{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "go-swagger";
  version = "0.26.1";

  src = fetchFromGitHub {
    owner = "go-swagger";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-gA7YpzroIP26u/kmbwlcYkWVfeJ8YDEAl0H9GGQrXA8=";
  };

  vendorSha256 = "sha256-eRcE6ai7076HqTWRJ8zKoV6/PJRgUpKvKF+0T7MgLQE=";

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
