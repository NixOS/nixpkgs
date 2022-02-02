{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "sshportal";
  version = "1.18.5";

  src = fetchFromGitHub {
    owner = "moul";
    repo = "sshportal";
    rev = "v${version}";
    sha256 = "1d9zws7b6ng23vyk8di5jmnbsxz7kaj4z8wz43wkwr6b65c2h0bf";
  };

  ldflags = [ "-X main.GitTag=${version}" "-X main.GitSha=${version}" "-s" "-w" ];

  vendorSha256 = "0fnn455adw4bhz68dpqaii08wv7lifdd5kx95rpqxsi2sqrzr4br";

  meta = with lib; {
    description = "Simple, fun and transparent SSH (and telnet) bastion server";
    homepage = "https://manfred.life/sshportal";
    license = licenses.asl20;
    maintainers = with maintainers; [ zaninime ];
  };
}
