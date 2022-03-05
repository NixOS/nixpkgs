{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "sshportal";
  version = "1.19.3";

  src = fetchFromGitHub {
    owner = "moul";
    repo = "sshportal";
    rev = "v${version}";
    sha256 = "sha256-8+UHG4xTH9h1IvMoOY7YHPClk4t2vWSBOUnYU6+mynQ=";
  };

  ldflags = [ "-X main.GitTag=${version}" "-X main.GitSha=${version}" "-s" "-w" ];

  vendorSha256 = "sha256-swDoQeO44fkpS2JNUAXaj3ZVjjzhoEr34YZ1/ArnLBk=";

  meta = with lib; {
    description = "Simple, fun and transparent SSH (and telnet) bastion server";
    homepage = "https://manfred.life/sshportal";
    license = licenses.asl20;
    maintainers = with maintainers; [ zaninime ];
  };
}
