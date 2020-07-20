{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "go-swagger";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "go-swagger";
    repo = pname;
    rev = "v${version}";
    sha256 = "05zyja58ff0k4fsfmb1j8q5p7lysi78m7jklrzz2xv8ianifkfbg";
  };

  vendorSha256 = "0vvr167spwk7whqzdp5vd8sm0qwc5g3namm4iqw3vff2pifjgs40";

  subPackages = [ "cmd/swagger" ];

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/go-swagger/go-swagger/cmd/swagger/commands.Version=${version} -X github.com/go-swagger/go-swagger/cmd/swagger/commands.Commit=${src.rev}" ];

  meta = with lib; {
    description = "Golang implementation of Swagger 2.0, representation of your RESTful API";
    homepage = "https://github.com/go-swagger/go-swagger";
    license = licenses.asl20;
    maintainers = with maintainers; [ kalbasit ];
  };
}
